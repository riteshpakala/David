//
//  ModuleConfig.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala Rao on 12/31/20.
//

import Foundation
import Granite
import SwiftUI

public struct ModuleConfig: GraniteModel {
    public var id: String {
        return "(\(index.x), \(index.y))"
    }
    
    public struct Index: GraniteModel {
        public static func == (lhs: Index, rhs: Index) -> Bool {
            lhs.x == rhs.x &&
            lhs.y == rhs.y
        }
        
        let x: Int
        let y: Int
        
        static var zero: Index {
            .init(x: 0, y: 0)
        }
    }
    
    enum CodingKeys: CodingKey {
        case index
    }
    
    var style: WindowStyle = .init()
    var kind: ModuleType = .unassigned
    let index: Index
    
    static var none: ModuleConfig {
        .init(index: .zero)
    }
    
    var detail: String {
        """
        Window: \(id)
        ------------
        index: (\(index.x), \(index.y))
        kind: \(kind)
        """
    }
    
    public static func == (lhs: ModuleConfig, rhs: ModuleConfig) -> Bool {
        lhs.index == rhs.index
    }
}

public enum ModuleType: GraniteModel {
    case favorites
    case recents
    
    case portfolio
    
    case topVolume(SecurityType)
    case winners(SecurityType)
    case losers(SecurityType)
    case winnersAndLosers(SecurityType)
    
    case floor
    
    case special
    
    case debug
    
    case unassigned
    
    var max: Int {
        switch self {
        case .winners,
             .losers,
             .topVolume,
             .winnersAndLosers,
             .recents :
            return 3
//        case .cta:
//            return 10000
        default:
            return 1
        }
    }
    
    var label: LocalizedStringKey {
        switch self {
        case .topVolume :
            return "top volume"
        case .winners:
            return "winners"
        case .losers:
            return "losers"
        default:
            return ""
        }
    }
}

public struct WindowStyle: Hashable, Equatable {
    public static func == (lhs: WindowStyle, rhs: WindowStyle) -> Bool {
        lhs.idealWidth == rhs.idealWidth &&
        lhs.idealHeight == rhs.idealHeight
    }
    
    
    var idealWidth: CGFloat = 375
    var idealHeight: CGFloat = 420
    
    
    static var minWidth: CGFloat = 300
    static var minHeight: CGFloat = 360
    static var maxWidth: CGFloat = 500
    static var maxHeight: CGFloat = 400
    
    static var windowSizeProxy: some View {
        GeometryReader { reader in
            Rectangle().frame(width: reader.size.width, height: reader.size.height, alignment: .center)
        }
    }
}
