import Granite
import SwiftUI

extension AssetSearch {
    struct Center: GraniteCenter {
        struct State: GraniteState {
            var securityType: SecurityType = .stock
            var query: String = ""
            
            var isEditing: Bool = false
            var isSearching: Bool = false
            
            var stocks: [Stock] = []
        }
        
        @Store public var state: State
        
        @Event public var search: Search.Reducer
        @Event public var searchLocal: SearchLocal.Reducer
    }
}
