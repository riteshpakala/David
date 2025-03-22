//
//  StockService.GetQuotes.swift
//  Stoic
//
//  Created by Ritesh Pakala Rao on 12/21/22.
//

import Granite
import SwiftUI
import Combine

extension StockService {
    struct Debug: GraniteReducer {
        typealias Center = StockService.Center
        
        @Event(.after) var response: Debug2.Reducer
        
        @Relay var network: NetworkService
        
        func reduce(state: inout Center.State) {
            state.count += 1
            state.testString = "debug 1 - \(state.count)"
            
            print("{TEST} runs first \(state.count)")
        }
    }
    
    struct Debug2: GraniteReducer {
        typealias Center = StockService.Center
        
        func reduce(state: inout Center.State) {
            state.count += 1
            state.testString = "debug 1 - \(state.count)"
            print("{TEST} runs second \(state.count)")
        }
    }
    
    struct DebugResponse: GraniteReducer {
        typealias Center = StockService.Center
        typealias Payload = Meta
        
        public struct Meta: GranitePayload {
            public var refresh: Bool
            public var syncWithStoics: Bool
            public var useStoics: Bool

            public init(syncWithStoics: Bool = false, refresh: Bool = false, useStoics: Bool = true) {
                self.syncWithStoics = syncWithStoics
                self.refresh = refresh
                self.useStoics = useStoics
            }
        }
        
        
        //@Event var response: DebugResponse2.Reducer
        
        func reduce(state: inout Center.State, payload: Payload) {
            state.count += 1
            
            state.testString = "debug 2 - \(state.count)"
        }
    }
    
    struct DebugResponse2: GraniteReducer {
        typealias Center = StockService.Center
        
        func reduce(state: inout Center.State) {
            state.count += 1
            state.testString = "debug 3 - \(state.count)"
        }
    }
}
