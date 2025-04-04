import Foundation
import Granite
import DavidKit

extension AssetSearch {
    struct Search: GraniteReducer {
        typealias Center = AssetSearch.Center
        
        @Event var response: GetSearchResponse.Reducer
        
        @Relay var service: StockService
        
        func reduce(state: inout Center.State) async {
            guard let result = await service.search(state.query) else {
                return
            }
            
            response.send(GetSearchResponse.Meta(data: result))
        }
        
        var behavior: GraniteReducerBehavior {
            .task(.userInitiated)
        }
    }
    
    struct SearchLocal: GraniteReducer {
        typealias Center = AssetSearch.Center
        
        public struct Meta: GranitePayload {
            public var data: [TickerSearch]
        }
        
        @Payload var meta: Meta?
        
        func reduce(state: inout Center.State) {
            guard let meta = self.meta else { return }
            
            let searchStocks = meta.data.map {
                StockServiceModels.Search.Stock(
                    exchangeName: $0.exchange ?? "",
                    symbolName: $0.symbol,
                    companyName: $0.name)
            }
            
            state.stocks = searchStocks.map { $0.asStock() }
        }
    }
    
    struct GetSearchResponse: GraniteReducer {
        typealias Center = AssetSearch.Center
        
        public struct Meta: GranitePayload {
            public var data: Requests.Stock.Search.Response
        }
        
        @Payload var meta: Meta?
        
        func reduce(state: inout Center.State) {
            guard let data = meta?.data else { return }
            var sanitizedStocks: [StockServiceModels.Search.Stock] = []
    
            let validExchanges: [String] = [StockServiceClient.Exchanges.nasdaq.rawValue.uppercased(), StockServiceClient.Exchanges.nyse.rawValue.uppercased()]
    
            for item in data {
                let keys = item.keys
    
    
                if  keys.contains(StockServiceModels.Search.Keys.countryCode.rawValue),
                    keys.contains(StockServiceModels.Search.Keys.issueType.rawValue),
                    keys.contains(StockServiceModels.Search.Keys.symbolName.rawValue),
                    keys.contains(StockServiceModels.Search.Keys.companyName.rawValue),
                    keys.contains(StockServiceModels.Search.Keys.exchangeName.rawValue)
                    {
    
                        if item[StockServiceModels.Search.Keys.countryCode.rawValue] == "US",
                            item[StockServiceModels.Search.Keys.issueType.rawValue] == "STOCK",
                            validExchanges.contains(item[StockServiceModels.Search.Keys.exchangeName.rawValue] ?? "") {
    
    
                            let searchStock: StockServiceModels.Search.Stock = .init(
                                exchangeName: item[StockServiceModels.Search.Keys.exchangeName.rawValue] ?? "",
                                symbolName: item[StockServiceModels.Search.Keys.symbolName.rawValue] ?? "",
                                companyName: item[StockServiceModels.Search.Keys.companyName.rawValue] ?? "")
                            
                            sanitizedStocks.append(searchStock)
                        }
    
                }
            }
            
            state.stocks = sanitizedStocks.map { $0.asStock() }
        }
    }
}
