//
//  Movers.swift
//  Stoic
//
//  Created by Ritesh Pakala Rao on 4/5/25.
//

import DavidKit

extension ModuleType {
    var categoryType: Movers.Category {
        switch self {
        case .topVolume:
            return .topVolume
        case .winners:
            return .winners
        case .losers:
            return .losers
        default:
            return .unassigned
        }
    }
}

