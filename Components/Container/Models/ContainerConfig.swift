//
//  ContainerConfig.swift
//  * stoic
//
//  Created by Ritesh Pakala Rao on 12/31/20.
//

import Foundation
import SwiftUI
import Granite

#if os(iOS)
import UIKit
#endif

public struct ContainerConfig: GraniteModel {
    public struct Page {
        let windows: [[ModuleType]]
    }
    
    public enum PageType: GraniteModel {
        case home
        case floor
        case intro
        case discuss
        case special
        
        public var page: Page {
            switch self {
            case .home:
                return .init(windows: [[.portfolio, .winners(.stock), .debug],
                                       [.unassigned, .losers(.stock), .unassigned],
                                       [.unassigned, .unassigned, .unassigned]])
            case .floor:
                return .init(windows: [[.floor]])
            case.special:
                return .init(windows: [[.special]])
            default:
                return .init(windows: [])
            }
        }
    }
    
    let kind: PageType
    
    static var none: ContainerConfig {
        return .init(kind: .home)
    }
}

extension ContainerConfig {
    public static var maxWindows: CGSize {
        ContainerConfig.isDesktop ? .init(3, 3) : .init(3, 3)
        //iPad can have 3, although mobile should be 1 width, mobile should also be scrollable the rest fixed
    }
    
    public static var isDesktop: Bool {
        #if os(macOS)
        return true
        #else
        return false
        #endif
    }
    
    public static var isIPad: Bool {
        #if os(iOS)
        return UIDevice.current.userInterfaceIdiom == .pad
        #else
        return false
        #endif
    }
    
    public static var isIPhone: Bool {
        #if os(iOS)
        return UIDevice.current.userInterfaceIdiom == .phone
        #else
        return false
        #endif
    }
    
    public static var iPhoneScreenWidth: CGFloat {
        #if canImport(UIKit)
        return UIScreen.main.bounds.width
        #else
        return 360
        #endif
    }
    
    public static var iPhoneScreenHeight: CGFloat {
        #if canImport(UIKit)
        return UIScreen.main.bounds.height - (ContainerStyle.ControlBar.iPhone.maxHeight + Brand.Padding.small)
        #else
        return 812
        #endif
    }
}
public struct ContainerStyle {
    static var idealWidth: CGFloat = 375
    static var idealHeight: CGFloat = 420
    static var minWidth: CGFloat = 320
    static var minHeight: CGFloat = 120
    static var maxWidth: CGFloat = 500
    static var maxHeight: CGFloat = 400
    
    public struct ControlBar {
        public struct iPhone {
            static var minHeight: CGFloat = 36
            static var maxHeight: CGFloat = 42
        }
        
        public struct Default {
            static var minWidth: CGFloat = 100
            static var maxWidth: CGFloat = 150
        }
    }
    
    public struct Floor {
        public struct iPhone {
            static var minHeight: CGFloat = 36
            static var maxHeight: CGFloat = 42
        }
        
        public struct Default {
            static var minWidth: CGFloat = 100
            static var maxWidth: CGFloat = 150
        }
    }
}
