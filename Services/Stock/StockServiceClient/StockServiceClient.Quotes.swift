//
//  StockService.Movers.swift
//  * stoic
//
//  Created by Ritesh Pakala Rao on 12/22/20.
//

import Foundation
import Combine
import Granite

extension StockServiceClient {
    public func getQuotes(symbols: String) -> AnyPublisher<[StockServiceModels.Quotes], URLError> {
        guard
            var urlComponents = URLComponents(string: quotesStoic)
            else { preconditionFailure("Can't create url components...") }
//        let regionQuery: URLQueryItem = .init(name: "region", value: "US")
        let symbolsQuery: URLQueryItem = .init(name: "data", value: symbols)
        
        urlComponents.queryItems = [symbolsQuery]
        
        guard
            let url = urlComponents.url
            else { preconditionFailure("Can't create url from url components...") }
        
        var request = URLRequest(
            url: url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0)
        
//        let headers = [
//            "x-rapidapi-key": "2a224e70a9msh9e0e2e3a2a20673p19f962jsn59435ee9b515",
//            "x-rapidapi-host": "apidojo-yahoo-finance-v1.p.rapidapi.com"
//        ]
        let headers = [
            "x-api-key": "ytpIkHWQvL712vQSQl0eS6hBDhEy8YVY9gkyonVD"
        ]
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        return session
                .dataTaskPublisher(for: request)
                .compactMap { [weak self] (data, response) -> [StockServiceModels.Quotes]? in
                    var movers: StockServiceModels.Quotes?
                    do {
                        try autoreleasepool {
                            movers = try JSONDecoder().decode(StockServiceModels.Quotes.self, from: data)
                        }
                    } catch let error {
                        movers = nil
                    }
                    
                    return movers != nil ? [movers!] : nil
                
                }.eraseToAnyPublisher()
    }
}

extension StockServiceModels {
    public struct Quotes: GraniteModel {
        public struct Keys {
            public static var topVolume: String = "MOST_ACTIVES"
            public static var gainers: String = "DAY_GAINERS"
            public static var losers: String = "DAY_LOSERS"
        }
        
        public struct QuoteResponse: GraniteModel {
            public struct QuoteResult: GraniteModel {
                let language: String
                let region: String
                let quoteType: String
                let quoteSourceName: String
                let triggerable: Bool
                let quoteSummary: QuoteSummary
                let currency: String
                let fiftyTwoWeekLowChange: Double?
                let fiftyTwoWeekLowChangePercent: Double?
                let fiftyTwoWeekRange: String?
                let fiftyTwoWeekHighChange: Double?
                let fiftyTwoWeekHighChangePercent: Double?
                let fiftyTwoWeekLow: Double?
                let fiftyTwoWeekHigh: Double?
                let exDividendDate: Int64?
                let earningsTimestamp: Int64?
                let earningsTimestampStart: Int64?
                let earningsTimestampEnd: Int64?
                let trailingPE: Double?
                let pegRatio: Double?
                let dividendsPerShare: Double?
                let revenue: Int64?
                let priceToSales: Double?
                let marketState: String?
                let epsTrailingTwelveMonths: Double?
                let epsForward: Double?
                let epsCurrentYear: Double?
                let epsNextQuarter: Double?
                let priceEpsCurrentYear: Double?
                let priceEpsNextQuarter: Double?
                let sharesOutstanding: Int64?
                let bookValue: Double?
                let fiftyDayAverage: Double
                let fiftyDayAverageChange: Double
                let fiftyDayAverageChangePercent: Double
                let twoHundredDayAverage: Double
                let twoHundredDayAverageChange: Double
                let twoHundredDayAverageChangePercent: Double
                let marketCap: Int64
                let forwardPE: Double?
                let priceToBook: Double?
                let sourceInterval: Int64?
                let exchangeDataDelayedBy: Int64?
                let exchangeTimezoneName: String
                let exchangeTimezoneShortName: String
                let pageViews: PageViews?
                let gmtOffSetMilliseconds: Int64?
                let esgPopulated: Bool?
                let tradeable: Bool
                let firstTradeDateMilliseconds: Int64?
                let priceHint: Int
                let totalCash: Int64?
                let floatShares: Int64?
                let ebitda: Int64?
                let shortRatio: Double?
                let preMarketChange: Double?
                let preMarketChangePercent: Double?
                let preMarketTime: Int64?
                let targetPriceHigh: Double?
                let targetPriceLow: Double?
                let targetPriceMedian: Double?
                let preMarketPrice: Double?
                let heldPercentInsiders: Double?
                let heldPercentInstitutions: Double?
                let postMarketChangePercent: Double?
                let postMarketTime: Int64?
                let postMarketPrice: Double?
                let postMarketChange: Double?
                let regularMarketChange: Double?
                let regularMarketChangePercent: Double?
                let regularMarketTime: Int64?
                let regularMarketPrice: Double?
                let regularMarketDayHigh: Double?
                let regularMarketDayRange: String?
                let regularMarketDayLow: Double?
                let regularMarketVolume: Int64?
                let sharesShort: Int64?
                let sharesShortPrevMonth: Int64?
                let shortPercentFloat: Double?
                let bid: Double?
                let ask: Double?
                let bidSize: Int64?
                let askSize: Int64?
                let exchange: String
                let market: String
                let messageBoardId: String?
                let fullExchangeName: String
                let shortName: String
                let longName: String
                let regularMarketOpen: Double?
                let averageDailyVolume3Month: Int64?
                let averageDailyVolume10Day: Int64?
                let beta: Double?
                let components: [String]?
                let symbol: String
            }
            
            let result: [QuoteResult]
            let error: String?
        }
        
        public struct QuoteSummary: GraniteModel {
            public struct Earnings: GraniteModel {
                public struct EarningsChart: GraniteModel {
                    public struct Quarterly: GraniteModel {
                        let date: String
                        let actual: Double
                        let estimate: Double
                    }
                    
                    let quarterly: [Quarterly]
                    let currentQuarterEstimate: Double
                    let currentQuarterEstimateDate: String
                    let currentQuarterEstimateYear: Int
                    let earningsDate: [Int64]
                }
                
                public struct FinancialsChart: GraniteModel {
                    public struct Yearly: GraniteModel {
                        let date: Int
                        let revenue: Int64
                        let earnings: Int64
                    }
                    
                    public struct Quarterly: GraniteModel {
                        let date: String
                        let revenue: Int64
                        let earnings: Int64
                    }
                    
                    let yearly: [Yearly]
                    let quarterly: [Quarterly]
                }
                
                let maxAge: Int
                let earningsChart: EarningsChart
                let financialsChart: FinancialsChart
                let financialCurrency: String
            }
        }
        
        public struct PageViews: GraniteModel {
            let midTermTrend: String
            let longTermTrend: String
            let shortTermTrend: String
        }
        
        
        
        let quoteResponse: QuoteResponse
    }
}
