//
//  Holdings._.swift
//  Stoic
//
//  Created by Ritesh Pakala Rao on 1/3/23.
//

import Foundation
import Granite

extension HoldingsService.Center {
    struct Start: GraniteReducer {
        typealias Center = HoldingsService.Center
        
        func reduce(state: inout Center.State) {
            state.wallet.current = state.wallet.total
            state.strategy = .init(value: state.wallet.total)
        }
    }
    
    struct Reset: GraniteReducer {
        typealias Center = HoldingsService.Center
        
        func reduce(state: inout Center.State) {
            var currentStrategy = state.strategy
            currentStrategy?.closingValue = state.value
            
            if let strategy = currentStrategy {
                state.pastStrategies.append(strategy)
            }
            
            state.strategy = nil
        }
    }
    
    struct Remove: GraniteReducer {
        typealias Center = HoldingsService.Center
        
        struct Meta: GranitePayload {
            var id: String
        }
        
        @Payload var meta: Meta?
        
        func reduce(state: inout Center.State) {
            guard let meta = self.meta else { return }
            
            state.pastStrategies.removeAll(where: { $0.id == meta.id })
        }
    }
}
