//
//  Broadcasts.Movers.swift
//  * stoic
//
//  Created by Ritesh Pakala Rao on 1/9/21.
//

import Foundation
import Granite
import SwiftUI

public class Movers: GraniteModel {
    public static func == (lhs: Movers, rhs: Movers) -> Bool {
        lhs.lastUpdated == rhs.lastUpdated
    }
    
    public enum Category: String {
        case topVolume
        case winners
        case losers
        case unassigned
    }
    
    public struct Categories: GraniteModel {
        public static func == (lhs: Movers.Categories, rhs: Movers.Categories) -> Bool {
            lhs.lastUpdated == rhs.lastUpdated
        }
        
        enum CodingKeys: CodingKey {
            case lastUpdated
            case topVolume
            case winners
            case losers
        }
        
        let lastUpdated: CFAbsoluteTime = CFAbsoluteTimeGetCurrent()
        let topVolume: [Security]
        let winners: [Security]
        let losers: [Security]
        
        public init(_ topVolume: [Security] = [],
                    _ winners: [Security] = [],
                    _ losers: [Security] = []) {
            self.topVolume = topVolume
            self.winners = winners
            self.losers = losers
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            if let stocks = topVolume as? [Stock] {
                try container.encode(stocks, forKey: .topVolume)
            }
            
            if let stocks = winners as? [Stock] {
                try container.encode(stocks, forKey: .winners)
            }
            
            if let stocks = losers as? [Stock] {
                try container.encode(stocks, forKey: .losers)
            }
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let stocksTopVolume: [Stock]? = try container.decode([Stock].self, forKey: .topVolume)
            
            let stocksWinners: [Stock]? = try container.decode([Stock].self, forKey: .winners)
            
            let stocksLosers: [Stock]? = try container.decode([Stock].self, forKey: .losers)
            
            self.init(stocksTopVolume ?? [],
                      stocksWinners ?? [],
                      stocksLosers ?? [])
        }
    }
    
    var lastUpdated: CFAbsoluteTime = CFAbsoluteTimeGetCurrent()
    var stocks: Categories
    var crypto: Categories
    
    init(stocks: Categories? = nil, crypto: Categories? = nil) {
        self.stocks = stocks ?? .init()
        self.crypto = crypto ?? .init()
    }
    
    public func updateStock(categories: Categories) {
        self.stocks = categories
        lastUpdated = CFAbsoluteTimeGetCurrent()
    }
    
    public func updateCrypto(categories: Categories) {
        self.crypto = categories
        lastUpdated = CFAbsoluteTimeGetCurrent()
    }
    
    public func get(_ securityType: SecurityType, category: Category) -> [Security]{
        switch category {
        case .winners:
            switch securityType {
            case .stock:
                return stocks.winners
            case .crypto:
                return crypto.winners
            default:
                return []
            }
        case .losers:
            switch securityType {
            case .stock:
                return stocks.losers
            case .crypto:
                return crypto.losers
            default:
                return []
            }
        case .topVolume:
            switch securityType {
            case .stock:
                return stocks.topVolume
            case .crypto:
                return crypto.topVolume
            default:
                return []
            }
        default:
            return []
        }
    }
}

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
