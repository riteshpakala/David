//
//  Window+State.swift
//  Stoic
//
//  Created by Ritesh Pakala Rao on 12/20/22.
//

import Foundation
import Granite

extension Module {
    struct Center: GraniteCenter {
        struct State: GraniteState {
            var config: ModuleConfig = .none
        }
        
        @Store var state: State
    }
}
