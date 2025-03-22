import Granite
import SwiftUI

extension HoldingsService {
    struct Center: GraniteCenter {
        struct State: GraniteState {
            var wallet: Wallet = .init()
            var strategy: Strategy? = nil
            var pastStrategies: [Strategy] = []
            
            var isStrategyLive: Bool {
                strategy != nil
            }
            
            var hasInvestments: Bool {
                strategy?.investments.count ?? 0 > 0 
            }
            
            var value: Double {
                ((strategy?.value ?? 0) + wallet.current)
            }
            
            var startingValue: Double {
                strategy?.startingValue ?? 0
            }
            
            var currentChange: Double {
                guard (value - startingValue) != startingValue else {
                    return 0.0
                }
                return ((value - startingValue) / startingValue).format(4)
            }
            
            var currentChangeDisplay: LocalizedStringKey {
                .init("\(isGaining ? "+" : "")\(currentChange)%")
            }
            
            var isGaining: Bool {
                currentChange >= 0
            }
            
            var colorScheme: Color {
                isGaining ? Brand.Colors.green : Brand.Colors.red
            }
            
            var isSyncing: Bool = false
            var lastSyncDate: Date? = nil
        }
        
        @Store(persist: "persistence.holdings.0012", autoSave: true, preload: true) public var state: State
        
        @Event var start: Start.Reducer
        @Event var reset: Reset.Reducer
        
        @Event var order: Order.Reducer
        @Event var sell: Sell.Reducer
        @Event var close: Close.Reducer
        @Event var sync: Sync.Reducer
        @Event var remove: Remove.Reducer
    }
    
    struct Wallet: GraniteModel {
        var isLocked: Bool = false
        
        var current: Double = 0.0
        
        var total: Double {
            Double(joinedPure)
        }
        
        var digit0: Int = 5
        var digit1: Int = 0
        var digit2: Int = 0
        var digit3: Int = 0
        var digit4: Int = 0
        var digit5: Int = 0
        
        var options: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        
        var joined: String {
            "$\(digit0)\(digit1)\(digit2)\(digit3)\(digit4)\(digit5)"
        }
        
        var joinedPure: Int {
            Int("\(digit0)\(digit1)\(digit2)\(digit3)\(digit4)\(digit5)") ?? 0
        }
    }
}
