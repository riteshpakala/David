//
//  AssetGridType.swift
//  Stoic
//
//  Created by Ritesh Pakala Rao on 12/21/22.
//

import Foundation

public enum AssetGridType: Equatable {
    case add
    case radio
    case standard
    case standardStoics
    case model
}

extension ModuleType {
    var assetGridType: AssetGridType {
        switch self {
//        case .floor:
//            return .add
//        case .strategy:
//            return .radio
//        case .portfolio:
//            return .add
        default:
            return .standard
        }
    }
    
    var assetGridTypeForHoldings: AssetGridType {
        switch self {
//        case .strategy:
//            return .radio
        default:
            return .standard
        }
    }
}
