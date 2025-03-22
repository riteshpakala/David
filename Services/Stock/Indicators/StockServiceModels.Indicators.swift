//
//  TonalService.Indicators.swift
//  * stoic
//
//  Created by Ritesh Pakala Rao on 1/5/21.
//

import Foundation
import Granite

extension StockServiceModels {
    public struct Indicators {
        public static let trailingDays: Int = 120
        
        public struct PairedSecurity {
            var base: Security
            var previous: Security
            
            var volatility: Volatility {
                Volatility.init(paired: self)
            }
            
            var toString: String {
                "Base: \(base.lastValue) // Prev: \(previous.lastValue)"
            }
        }
        
        public enum Kind: String, GraniteModel, CaseIterable, Identifiable {
            public var id: String {
                self.rawValue
            }
            
            case avgMomentum = "Average Momentum"
            case avgVolMomentum = "Average Volume Momentum"
            case avgVolatility = "Average Volatility"
            case avgVolVolatility = "Average Volume Volatility"
            case avgChange = "Average Change"
            case avgVolChange = "Average Volume Change"
            case avgVolume = "Average Volume"
            case vwa = "Volume Weighted Average"
            case sma = "Simple Moving Average"
            case smaWa = "SMA Weighted Average"
            case ema = "Exponential Moving Average"
            case emaWa = "EMA Weighted Average"
            case momentum = "Momentum"
            case volatility = "Volatility"
            case change = "Change"
            case volMomentum = "Volume Momentum"
            case macD = "Moving Average Conv./Div."
            case macDSignal = "Moving Average Conv./Div.'s EMA Signal"
            case stochasticK = "Stochastic Oscillator K"
            case stochasticD = "Stochastic Oscillator D"
            
        }
        
        public enum Context: String, GraniteModel {
            case high
            case close
            case low
        }
        
        let security: Security
        let history: [Security]
        let historyPaired: [PairedSecurity]
        
        public init(_ security: Security,
                    with securities: [Security],
                    preview: Bool = false,
                    sort: Bool = false) { //sortAsc
            self.security = security
            
            if preview {
                self.history = Array(securities.suffix(Indicators.trailingDays))
            } else {
                let securities: [Security] = sort ? Array(securities.sortAsc.filterBelow(security.date)) : Array(securities.filterBelow(security.date)) //quote.dailySecurities.sortDesc.filterBelow(security.date)
                self.history = securities
            }
            
            if securities.count > 1 {
                var pairings: [PairedSecurity] = []
                for i in 0..<securities.count-1 {
                    let base = securities[i]
                    let previous = securities[i+1]
                    
                    pairings.append(.init(base: base, previous: previous))
                }
                self.historyPaired = pairings
            } else {
                self.historyPaired = []
            }
        }
    }
}

extension StockServiceModels.Indicators {
    var basePair: PairedSecurity {
        .init(base: security, previous: historyPaired.last?.base ?? security)
    }
    
    var change: Double {
        (basePair.base.lastValue - basePair.previous.lastValue) / basePair.previous.lastValue
    }
    
    var volChange: Double {
        (basePair.base.lastValue - basePair.previous.lastValue) / basePair.previous.lastValue
    }
}

extension Security {
    public func value(forContext context: StockServiceModels.Indicators.Context) -> Double {
        
        switch context {
        case .high:
            return highValue
        case .close:
            return lastValue
        case .low:
            return lowValue
        }
    }
}
