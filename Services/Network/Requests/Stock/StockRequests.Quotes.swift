import Foundation

extension Requests.Stock {
    struct GetQuotes : Request {
        typealias Response = StockServiceModels.Quotes
        
        enum CodingKeys: CodingKey {
            
        }
        
        var path: String { "https://wzda7iwzjd.execute-api.us-west-1.amazonaws.com/default/stoic-search" }
        
        var method: RequestMethod { .get }
        
        var symbols: String
        
        init(symbols: String) {
            self.symbols = symbols
        }
        
        var customHeaders: [String : String] {
            [
                "x-api-key": "ytpIkHWQvL712vQSQl0eS6hBDhEy8YVY9gkyonVD"
            ]
        }
        
        var customQueries: [String : String] {
            [
                "data": symbols
            ]
        }
        
        var ignoresEndpoint: Bool {
            true
        }
    }
}

//MARK: Response Models

extension Requests.Stock.GetQuotes {
    public struct Quotes: Codable {
        public struct Keys {
            public static var topVolume: String = "MOST_ACTIVES"
            public static var gainers: String = "DAY_GAINERS"
            public static var losers: String = "DAY_LOSERS"
        }
        
        public struct QuoteResponse: Codable {
            public struct QuoteResult: Codable {
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
        
        public struct QuoteSummary: Codable {
            public struct Earnings: Codable {
                public struct EarningsChart: Codable {
                    public struct Quarterly: Codable {
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
                
                public struct FinancialsChart: Codable {
                    public struct Yearly: Codable {
                        let date: Int
                        let revenue: Int64
                        let earnings: Int64
                    }
                    
                    public struct Quarterly: Codable {
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
        
        public struct PageViews: Codable {
            let midTermTrend: String
            let longTermTrend: String
            let shortTermTrend: String
        }
        
        
        
        let quoteResponse: QuoteResponse
    }
}

extension StockServiceModels.Quotes.QuoteResponse.QuoteResult {
    public func asStock(interval: SecurityInterval = .day) -> Stock {
            let open: Double = regularMarketPrice ?? 0.0
            let high: Double = regularMarketDayHigh ?? 0.0
            let low: Double = regularMarketDayLow ?? 0.0
            let close: Double = regularMarketPrice ?? 0.0
            let volume: Double = Double(regularMarketVolume ?? 0)
        
        return Stock.init(
            ticker: symbol,
            date: Date(),
            open: open,
            high: high,
            low: low,
            close: close,
            volume: volume,
            changePercent: (regularMarketChangePercent ?? 0.0)/100,
            changeAbsolute: (regularMarketChange ?? 0.0),
            interval: interval,
            exchangeName: exchange,//TODO:??
            name: shortName,
            hasStrategy: false,
            hasPortfolio: false)
    }
}
