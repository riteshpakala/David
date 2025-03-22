import Granite
import SwiftUI

extension SinatraService {
    struct Center: GraniteCenter {
        struct State: GraniteState {
            
        }
        
        @Event var run: Run.Reducer
        
        @Store public var state: State
    }
}
