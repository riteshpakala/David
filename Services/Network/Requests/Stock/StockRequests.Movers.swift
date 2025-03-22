import Foundation

extension Requests.Stock {
    struct GetMovers {
        struct New : Request {
            
            typealias Response = Movers
            
            var path: String { "https://apidojo-yahoo-finance-v1.p.rapidapi.com/market/v2/get-movers" }
            
            var method: RequestMethod { .get }
            
            var count: Int
            
            init(count: Int = 12) {
                self.count = count
            }
            
            var customHeaders: [String : String] {
                [
                    "x-rapidapi-key": "2a224e70a9msh9e0e2e3a2a20673p19f962jsn59435ee9b515",
                    "x-rapidapi-host": "apidojo-yahoo-finance-v1.p.rapidapi.com"
                ]
            }
            
            var ignoresEndpoint: Bool {
                true
            }
        }
        
        struct Stoic : Request {
            
            typealias Response = MoversStoic
            
            var path: String { "https://yqqa677w92.execute-api.us-west-1.amazonaws.com/default/stoic-movers" }
            
            var method: RequestMethod { .get }
            
            var count: Int
            
            init(count: Int = 12) {
                self.count = count
            }
            
            var customHeaders: [String : String] {
                [
                    "x-api-key": "2jzhkSc60N3LOdpI9J0NW5J6MnHbedFU2ypEJvcX"
                ]
            }
            
            var customQueries: [String : String] {
                [
                    "TableName" : "stoic-stock-movers",
                    "pageid" : Date.today.nextValidTradingDay.asString
                ]
            }
            
            var ignoresEndpoint: Bool {
                true
            }
        }
    }
}

//MARK: Response Models

extension Requests.Stock.GetMovers {
    public struct Movers: NetworkResponseData {
        let finance: Finance
    }
    
    public struct MoversStoic: NetworkResponseData {
        struct Item: Codable {
            let pageid: String
            let date: Int
            let data: StockServiceModels.Movers
        }
        let Items: [Item]
    }
    
    public struct MoversArchiveable: NetworkResponseData {
        var movers: StockServiceModels.Movers?
        var quotes: [StockServiceModels.Quotes]
        
        public init(_ movers: StockServiceModels.Movers? = nil,
                    _ quotes: [StockServiceModels.Quotes] = []) {
            self.movers = movers
            self.quotes = quotes
        }
    }
    
    public struct Finance: Codable {
        public struct MoversResult: Codable {
            let id: String
            let title: String
            let description: String
            let canonicalName: String
            let criteriaMeta: CriteriaMeta
            let rawCriteria: String
            let start: Int
            let count: Int
            let total: Int
            let quotes: [Quote]
            let predefinedScr: Bool
            let versionId: Int
        }
        
        public struct CriteriaMeta: Codable {
            let size: Int
            let offset: Int
            let sortField: String
            let sortType: String
            let quoteType: String
            let topOperator: String
            let criteria: [Criteria]
        }
        
        public struct Criteria: Codable {
            let field: String
            
            let operators: [String]
            let values: [Double]
            let labelsSelected: [Int]
        }
        
        public struct Quote: Codable {
            let language: String
            let region: String
            let quoteType: String
            let quoteSourceName: String
            let triggerable: Bool
            let sourceInterval: Int32
            let exchangeDataDelayedBy: Int32
            let exchangeTimezoneName: String
            let exchangeTimezoneShortName: String
            let gmtOffSetMilliseconds: Int32
            let esgPopulated: Bool
            let tradeable: Bool
            let firstTradeDateMilliseconds: Int64?
            let priceHint: Int64
            let exchange: String
            let market: String
            let fullExchangeName: String
            let marketState: String
            let symbol: String
        }
        
        let result: [MoversResult]
        let error: String?
    }
}
