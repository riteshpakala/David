import Granite
import SwiftUI

extension AssetSection {
    struct Center: GraniteCenter {
        struct State: GraniteState {
            var securityType: SecurityType = .unassigned
            var toggleTitleIndex: Int = 0
            var context: ModuleType = .unassigned
        }
        
        @Store public var state: State
    }
}

extension AssetSection.Center {
    var toggleTitle: Bool {
        switch state.context {
        case .winnersAndLosers:
            return true
        default:
            return false
        }
    }
    
    var toggleTitleLabels: [String] {
        switch state.context {
        case .winnersAndLosers:
            return ["winners", "losers"]
        default:
            return []
        }
    }
}
