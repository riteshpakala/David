//
//  StockRequests.History.swift
//  Stoic
//
//  Created by Ritesh Pakala Rao on 1/3/23.
//

import Foundation
import Granite

extension Requests.Stock {
    struct GetHistory : Request {
        typealias Response = Stock
        
        enum CodingKeys: CodingKey {
            
        }
        
        var path: String { "https://query1.finance.yahoo.com/v8/finance/chart/\(ticker)" }
        
        var method: RequestMethod { .get }
        
        var ticker: String
        var pastEpoch: String
        var futureEpoch: String
        var interval: SecurityInterval
        
        init(ticker: String, daysAgo: Int = 2400, interval: SecurityInterval = .day) {
            self.ticker = ticker
            
            let todaysDate: Date = Date.today//.advanceDate(value: -30)//Calendar.nyCalendar.date(byAdding: .hour, value: -1, to: Date.today) ?? Date.today
                
            let pastDate: Date = Date.today.advanceDate(value: -1*abs(daysAgo))
            
            self.pastEpoch = "\(Int(pastDate.timeIntervalSince1970))"
            self.futureEpoch = "\(Int(todaysDate.timeIntervalSince1970))"
            
            self.interval = interval
        }
        
        var ignoresEndpoint: Bool {
            true
        }
        
        var customQueries: [String : String] {
            [
                "period1" : pastEpoch,
                "period2" : futureEpoch,
                "region" : "US",
                "lang" : "en-US",
                "includePrePost" : "true",
                "interval" : interval.rawValue,
                "corsDomain" : "finance.yahoo.com",
                ".tsrc" : "finance"
            ]
        }
    }
}

extension Requests.Stock.GetHistory {
    public struct Stock: GraniteModel {
        public struct Chart: GraniteModel {
            public struct Result: GraniteModel {
                public struct Meta: GraniteModel {
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
            public struct Period: GraniteModel {
                let timezone: String
                let start: Int64
                let end: Int64
                let gmtoffset: Int64
            }
            
            public struct TradingPeriod: GraniteModel {
                let pre: [[Period]]
                let regular: [[Period]]
                let post: [[Period]]
            }
            
            public struct CurrentTradingPeriod: GraniteModel {
                let pre: Period
                let regular: Period
                let post: Period
            }
            
            public struct Indicators: GraniteModel {
                public struct Quote: GraniteModel {
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
