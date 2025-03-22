import Foundation
import Granite

extension StockService {
    struct Center: GraniteCenter {
        struct State: GraniteState {
            
            let service: StockServiceClient = .init()
            
            var movers: Movers = .init()
            
            var stocks: [String : [String : [Stock]]] = [:]
            
            var testString: String = ""
            
            var count: Int = 0
        }
        
        @Store(persist: "persistence.stocks.0001", autoSave: true) public var state: State
        
        @Event public var getMovers: GetMovers.Reducer
        @Event public var getHistory: GetHistory.Reducer
        @Event public var getHistoryDebug: GetHistoryDebug.Reducer
        
        @Event public var debug: Debug.Reducer
        
        @Notify(GetHistoryResponse.self) public var getHistoryResponse
        @Notify(GetHistoryDebugResponse.self) public var getHistoryDebugResponse
    }
}
