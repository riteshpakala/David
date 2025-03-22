import Granite
import SwiftUI

extension Sinatra {
    struct Center: GraniteCenter {
        struct State: GraniteState {
            
        }
        
        @Store public var state: State
    }
}
