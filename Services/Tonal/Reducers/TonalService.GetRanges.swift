import Granite
import Foundation

extension TonalService {
    struct GetRanges: GraniteReducer {
        typealias Center = TonalService.Center
        
        struct Meta: GranitePayload {
            var stocks: [Stock]
            var days: Int
        }
        
        struct Result: GraniteModel {
            var ranges: [TonalRange]
            var days: Int
        }
        
        @Payload var meta: Meta?
        
        func reduce(state: inout Center.State) {
            guard let meta = self.meta else { return }
            
            guard let last = meta.stocks.last else {
                return
            }
            
            let stock = last
            let stocks = meta.stocks
            
            let securities = stocks
            let days: Int = meta.days
            
            //Tonal Ranges
            //DEV: memory access error (CoreData)
            let orderedSecurities = (Array(securities).sortDesc as? [Stock]) ?? []
            
            let count = orderedSecurities.count

            var volatilities: [Date:Double] = [:]
            var volatilityCoeffecients: [Date:Double] = [:]
             
            for (index, security) in orderedSecurities.enumerated() {
                // Standard deviation calculation for yearly variance
                //
                let trailing = orderedSecurities.suffix(count - index).prefix(24)//24)
                let sum = trailing.map({ $0.lastValue }).reduce(0.0, +)
                let mean = sum/Double(trailing.count)
                
                let deviations = trailing.map({ pow($0.lastValue - mean, 2) }).reduce(0.0, +)
                let avgDeviation = deviations/Double(trailing.count - 1)
                
                let standardDeviation = sqrt(avgDeviation)
                volatilities[security.date] = standardDeviation
                volatilityCoeffecients[security.date] = standardDeviation/mean
            }

            let targetComparables = Array(orderedSecurities.prefix(days))

            let chunks = orderedSecurities.chunked(into: days)
            let scrapeTop = Array(chunks.suffix(chunks.count - 1))
            
            let baseRange = targetComparables.baseRange()
            var candidates : [TonalRange] = [baseRange]
            for chunk in scrapeTop {
                guard chunk.count == days else { continue }
                
                var similarities: [Double] = []
                for i in 0..<chunk.count {
    //                let targetCoeffecient = volatilityCoeffecients[targetComparables[i].date] ?? 0.0
    //                let chunkDayCoeffecient = volatilityCoeffecients[chunk[i].date] ?? 0.0
                    
                    let targetVol = volatilities[targetComparables[i].date] ?? 0.0
                    let chunkVol = volatilities[chunk[i].date] ?? 0.0
                    similarities.append(normalizeSim(targetVol/chunkVol))
                }
                
                if similarities.filter( { !threshold($0) } ).isEmpty {
                    let dates: [Date] = chunk.map { $0.date }
                    
                    let tSimilarities: [TonalSimilarity] = dates.enumerated().map {
                        TonalSimilarity.init(date: $0.element,
                                             similarity: similarities[$0.offset]) }
                    
                    let tIndicators: [TonalIndicators] = dates.map {
                        TonalIndicators.init(date: $0,
                                             volatility: volatilities[$0] ?? 0.0,
                                             volatilityCoeffecient: volatilityCoeffecients[$0] ?? 0.0 ) }
                    
                    candidates.append(.init(objects: chunk,
                                       orderedSecurities
                                           .expanded(from: chunk),
                                       tSimilarities,
                                       tIndicators))
                }
            }
            
            state.tonalRange = .init(ranges: candidates, days: days)
        }
        
        func threshold(_ item: Double) -> Bool {
            return item <= 1.0 && item >= 0.45
        }
        
        func normalizeSim(_ item: Double) -> Double {
            guard item > 1.0 else {
                return item
            }
            
            let diff = item - 1.0
            
            return 1.0 - diff
        }
    }
}
