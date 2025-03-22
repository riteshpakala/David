import Granite
import Foundation

class TonalGenerateRemote {
    static let shared: TonalGenerateRemote = .init()
    var cancel: Bool = false {
        didSet {
            wait = cancel
        }
    }
    var wait: Bool = false
}
extension TonalService {
    struct Generate: GraniteReducer {
        typealias Center = TonalService.Center
        
        struct Meta: GranitePayload {
            var stocks: [Stock]
            var range: TonalRange
            var progressReducer: EventExecutable
            var days: Int
            var context: StockServiceModels.Indicators.Context
            var variant1: StockServiceModels.Indicators.Variant
            var variant2: StockServiceModels.Indicators.Variant
        }
        
        struct MetaResult: GranitePayload {
            var days: Int
            var daysIndex: Int
            var error: Bool = false
            var training: Bool = false
            var complete: Bool = false
            var model: SVMModel? = nil
        }
        
        @Payload var meta: Meta?
        
        var thread: DispatchQueue? {
            DispatchQueue.global(qos: .utility)
        }
        
        func reduce(state: inout Center.State) {
            guard let meta = self.meta else { return }
            
            guard let last = meta.stocks.last else {
                return
            }
            
            let stocks = Array(meta.stocks.sortAsc.prefix(meta.stocks.count - 1))
            let stock = stocks.last ?? last
            let dates = Array(meta.range.dates.sortAsc.prefix(meta.range.dates.count - 1))
            
            //TODO: the way progress is being calculated not is like, really bad.
            
            meta.progressReducer.send(MetaResult(days: dates.count + 2,
                                                 daysIndex: 1))
            
//            let indicators = StockServiceModels.Indicators.init(stock, with: stocks)
            
            meta.progressReducer.send(MetaResult(days: dates.count + 2,
                                                 daysIndex: 2))
            
            let securities = stocks
            let days: Int = meta.days
            //4 - 28 tonality days
            //Imbhs randomness
            //each iteration picks a random
            //
            let tonality: Tonality = .init()
            
            //Training
            let dataForDavid: DataSet = DataSet(
                dataType: .Regression,
                inputDimension: 9,
                outputDimension: 1)
            
            var dataPoints: [IMBHSDataPoint] = []
            for (i, date) in dates.enumerated() {
                guard TonalGenerateRemote.shared.cancel == false  else {
                    break
                }
                
                guard let stock = securities.first(where: { $0.date.simple == date.simple }) else {
                    
                    GraniteLogger.info("-- invalid bucket for security --", .ml, focus: true)
                    continue
                }
                
                do {
                    let indicators = StockServiceModels.Indicators.init(stock, with: stocks)
                    
                    let dataSet = TonalityDataSet(indicators, context: meta.context)
                    
                    let v1Days = tonality.minDays.randomBetween(tonality.maxDays + 1)
                    let v2Days = tonality.minDays.randomBetween(tonality.maxDays + 1)
                    let v0Days = tonality.minDays.randomBetween(tonality.maxDays + 1)
                    
                    let data = dataSet.asArrayIMBHS(meta.variant1,
                                                    meta.variant2,
                                                    days1: v1Days,
                                                    days2: v2Days,
                                                    days0: v0Days)
                    try dataForDavid.addDataPoint(
                        input: data.asOutput,
                        output: dataSet.output,
                        label: stock.date.asString)
                    
                    dataPoints.append(data)
                    
                    print(data.description)
                    
                    guard TonalGenerateRemote.shared.cancel == false  else {
                        break
                    }
                    
                    meta.progressReducer.send(MetaResult(days: dates.count + 2,
                                                         daysIndex: i + 3))
                }
                catch {
                    GraniteLogger.error("invalid dataSet", .ml, focus: true)
                }
            }
            
            guard TonalGenerateRemote.shared.cancel == false else {
                return
            }
            
            let david = SVMModel(
                problemType: .ϵSVMRegression,
                kernelSettings:
                KernelParameters(type: .Polynomial,
                                 degree: 3,
                                 gamma: 0.3,
                                 coef0: 0.0))

            david.Cost = 1e3
            
            david.context = meta.context
            david.dataPoints = dataPoints
            
            meta.progressReducer.send(MetaResult(days: 0, daysIndex: 0, training: true))
            
            david.train(data: dataForDavid)
            
            meta.progressReducer.send(MetaResult(days: 0, daysIndex: 0, complete: true, model: david))
            
            state.model = david
        }
    }
}
