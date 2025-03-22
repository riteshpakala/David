import Granite
import SwiftUI

extension Floor {
    struct Center: GraniteCenter {
        struct State: GraniteState {
            
        }
        
        @Store public var state: State
    }
}
