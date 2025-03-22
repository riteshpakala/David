//
//  Playground.Predict.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/2/23.
//

import Foundation
import SwiftUI
import Granite

extension Playground {
    struct SetTemperature: GraniteReducer {
        typealias Center = Playground.Center
        
        struct Meta: GranitePayload {
            let temperature: CGPoint
        }
        
        @Payload var meta: Meta?
        
        func reduce(state: inout Center.State) {
            guard let meta = self.meta else { return }
            
        }
    }
    
    struct Predict: GraniteReducer {
        typealias Center = Playground.Center
        
        func reduce(state: inout Center.State) {
            
            let dates = state.selectedTonalRange?.dates.sortAsc
            guard let lastDate = dates?.last else {
                return
            }
            
            guard let refStock = state.stocks.last(where: { $0.date == lastDate }) else { return }
            
            
            guard state.selectedIndicators.count >= 2 else { return }
            let variant1 = state.selectedIndicators[0]
            let variant2 = state.selectedIndicators[1]
//            guard let refStock = state.stock else { return }
            
            let context: StockServiceModels.Indicators.Context = state.model?.context ?? .close
            
//            let scale = (state.temperatureX - 0.5) * 2 // -1 <-> +1
//            let scaleVolume = (state.temperatureY - 0.5) * 2 // -1 <-> +1
//
//            let newHigh = (refStock.high * scale) + refStock.high
//            let newClose = (refStock.close * scale) + refStock.close
//            let newLow = (refStock.low * scale) + refStock.low
//            let newVolume = (refStock.volume * scaleVolume) + refStock.volume
            
            let inputScale: String = """
            [Prediction Input Scale]
            high: \(refStock.high)
            close: \(refStock.close)
            low: \(refStock.low)
            
            temperature: \(Tonality.scale(1.0 - state.temperatureY.asDouble))
            tonality: \(Tonality.scale(state.temperatureX.asDouble))
            
            \(dates?.first?.asString) - \(lastDate.asString)
            ref stock date: \(refStock.date.asString)
            
            """
            
            let nextTradingDay = Date.nextTradingDay
            
            print(inputScale)
            
            let stock: Stock = refStock /*.init(ticker: refStock.ticker,
                                        date: refStock.date,
                                        open: refStock.open,
                                        high: newHigh,
                                        low: newLow,
                                        close: newClose,
                                        volume: refStock.volume,
                                        changePercent: refStock.changePercent,
                                        changeAbsolute: refStock.changeAbsolute,
                                        interval: refStock.interval,
                                        exchangeName: refStock.exchangeName,
                                        name: refStock.name,
                                        hasStrategy: refStock.hasStrategy,
                                        hasPortfolio: refStock.hasPortfolio)*/
            
            let dataForDavid: DataSet = DataSet(
                dataType: .Regression,
                inputDimension: 9,
                outputDimension: 1)
            
            let indicators = StockServiceModels
                .Indicators
                .init(stock, with: state.stocks)
            
            let dataSet = TonalityDataSet(indicators)
            
            try? dataForDavid.addDataPoint(
                input: dataSet.asArrayIMBHS(variant1,
                                            variant2,
                                            days1: Tonality.scale(state.temperatureX.asDouble),
                                            days2:  Tonality.scale(state.temperatureX.asDouble),
                                            days0: Tonality.scale(1.0 - state.temperatureY.asDouble)).asOutput,
                output: dataSet.output,
                label: nextTradingDay.asString)
            
            state.model?.predictValues(data: dataForDavid)
            
            guard let output = dataForDavid.singleOutput(index: 0) else {
                return
            }
            
            let adjusted = state.temperature
            
            state.prediction = (output - refStock.value(forContext: context)) / stock.value(forContext: context)
            state.predictionIsGainer = output > refStock.value(forContext: context)
            
            
            let prediction: String = """
            [Output]
            ref: \(refStock.value(forContext: context))
            \(output)
            \(state.prediction)
            """
            
            print(prediction)
            
            state.predictionState = .complete
        }
        
        var thread: DispatchQueue? {
            DispatchQueue.global(qos: .utility)
        }
    }
}
