//
//  StockService.Stocks.swift
//  * stoic
//
//  Created by Ritesh Pakala Rao on 12/23/20.
//

import Foundation
import Combine
import GraniteUI

extension StockServiceClient {
    public func getStockChart(matching ticker: String, from pastEpoch: String, to futureEpoch: String, interval: SecurityInterval) -> AnyPublisher<[StockServiceModels.Stock], URLError> {
        guard
            let urlComponents = URLComponents(string: yahooV8(matching: ticker, from: pastEpoch, to: futureEpoch, interval: interval))
            else { preconditionFailure("Can't create url components...") }

        guard
            let url = urlComponents.url
            else { preconditionFailure("Can't create url from url components...") }
        
        return session
                .dataTaskPublisher(for: url)
                .compactMap { [weak self] (data, response) -> [StockServiceModels.Stock]? in
                    var chart: StockServiceModels.Stock?
                    do {
                        try autoreleasepool {
                            chart = try JSONDecoder().decode(StockServiceModels.Stock.self, from: data)
                        }
                    } catch let error {
                        chart = nil
                    }
                    
                    return chart != nil ? [chart!] : nil
                    
//                    if let content = String(data: data, encoding: .utf8),
//                       let stockData = StockServiceUtilities.parseCSV(ticker: ticker, content: content) {
//
//                        for i in 0..<max(stockData.count - 31, 1) {
//                            _ = stockData[i].update(
//                                historicalTradingData: Array(stockData[i + 1...i + 30]),
//                                rsiMax: 20)
//                        }
//
//                        return stockData.filter( { $0.dateData.asString != $0.lastStockData.dateData.asString } )
//                    } else {
//                        return nil
//                    }
                
                }.eraseToAnyPublisher()
    }
}
extension StockServiceModels {
    public struct Stock: Codable {
        public struct Chart: Codable {
            public struct Result: Codable {
                public struct Meta: Codable {
                    let currency: String
                    let symbol: String
                    let exchangeName: String
                    let instrumentType: String
                    let firstTradeDate: Int64
                    let regularMarketTime: Int64
                    let gmtoffset: Int64
                    let timezone: String
                    let exchangeTimezoneName: String
                    let regularMarketPrice: Double?
                    let chartPreviousClose: Double?
                    let previousClose: Double?
                    let scale: Int?
                    let priceHint: Int?
                    let currentTradingPeriod: CurrentTradingPeriod?
                    let tradingPeriods: TradingPeriod?
                    let dataGranularity: String
                    let range: String
                    let validRanges: [String]
                }
                let meta: Meta
                let timestamp: [Int64]
                let indicators: Indicators
            }
            public struct Period: Codable {
                let timezone: String
                let start: Int64
                let end: Int64
                let gmtoffset: Int64
            }
            
            public struct TradingPeriod: Codable {
                let pre: [[Period]]
                let regular: [[Period]]
                let post: [[Period]]
            }
            
            public struct CurrentTradingPeriod: Codable {
                let pre: Period
                let regular: Period
                let post: Period
            }
            
            public struct Indicators: Codable {
                public struct Quote: Codable {
                    let close: [Double?]
                    let volume: [Double?]
                    let low: [Double?]
                    let open: [Double?]
                    let high: [Double?]
                }
                
                let quote: [Quote]
            }
            
            let result: [Result]
            let error: String?
        }
        let chart: Chart
    }
    
    
}
