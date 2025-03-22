import Granite
import SwiftUI

extension Portfolio {
    struct Center: GraniteCenter {
        struct State: GraniteState {
        }
        
        @Store public var state: State
    }
}
