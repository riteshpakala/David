//
//  StockServiceModels.Indicators.Variant.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/4/23.
//

import Foundation
import Granite

extension StockServiceModels.Indicators {
    public enum Variant: String, GraniteModel {
        case smawa = "SMA Weighted Average"
        case emawa = "EMA Weighted Average"
        case macd = "Moving Average Conv./Div."
        case macdsignal = "Moving Average Conv./Div.'s EMA Signal"
        case volchange = "Average Volume Change"
        case stochd = "Stochastic Oscillator D"
        case stochk = "Stochastic Oscillator K"
        case volatility = "Volatility"
        case momentum = "Momentum"
        case change = "Change"
        case vwa = "Volume Weighted Average"
        
        func compute(_ ind: StockServiceModels.Indicators,
                     context: StockServiceModels.Indicators.Context,
                     days: Int) -> Double {
            switch self {
            case .smawa:
                return ind.smaWA(days, context: context)
            case .emawa:
                return ind.emaWA(days, context: context)
            case .macd:
                return ind.macDAverage(days, context: context)
            case .macdsignal:
                return ind.macDSignal(days, context: context)
            case .volchange:
                return ind.avgVolChange(days)
            case .stochd:
                return ind.stochastic.values.percentDs.first ?? 0.0
            case .stochk:
                return ind.stochastic.values.percentKs.first ?? 0.0
            case .volatility:
                return ind.avgChange(days) + 1
            case .momentum:
                return ind.avgMomentum(days) + 1
            case .change:
                return ind.basePair.volatility.change
            case .vwa:
                return ind.vwa()
            
            }
        }
        var displayName: String {
            switch self {
            case .smawa:
                return "SMAWA"
            case .emawa:
                return "EMAWA"
            case .macd:
                return "MacD"
            case .macdsignal:
                return "MacD Signal"
            case .volchange:
                return "Vol. Change"
            case .stochd:
                return "Stoch. D"
            case .stochk:
                return "Stoch. K"
            case .vwa:
                return "VWA"
            default :
                return self.rawValue
            }
        }
        
        static var nonDefaults: [Variant] {
            [
                .smawa,
                .emawa,
                .macd,
                .macdsignal,
                .volchange,
                .stochd,
                .stochk
            ]
        }
    }
}
