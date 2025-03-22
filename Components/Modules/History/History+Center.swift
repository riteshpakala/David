import Granite
import SwiftUI

extension History {
    struct Center: GraniteCenter {
        struct State: GraniteState {
            
        }
        
        @Store public var state: State
    }
}
