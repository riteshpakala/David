//
//  ExperienceState.swift
//  * stoic
//
//  Created by Ritesh Pakala Rao on 12/31/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import Granite
import SwiftUI
import Combine

extension Container {
    struct Center: GraniteCenter {
        
        enum CaptureStatus: AnyStatus {
            case capturing
            case captured
        }
        
        struct State: GraniteState {
            
            @Geometry var geometry: GeometryProxy?

            var activeModuleConfigs: [[ModuleConfig]] = []
            
            var config: ContainerConfig = .init(kind: .home)
        }
        
        @Store public var state: State
        
        //@Event(.onAppear) var didAppear: DidAppear.Reducer
        //@Event var changeTab: ChangeTab.Reducer
    }
}

extension Container.Center {
    public var environmentMinSize: CGSize {
        return .init(
            CGFloat(state.activeModuleConfigs.count == 0 ?
                        Int(ContainerStyle.minWidth) :
                        state.activeModuleConfigs[0].count)*WindowStyle.minWidth,
            CGFloat(state.activeModuleConfigs.count)*WindowStyle.minHeight)
    }
    
    public var environmentMaxSize: CGSize {
        return .init(
            CGFloat(state.activeModuleConfigs.count == 0 ?
                        Int(ContainerStyle.minWidth) :
                        state.activeModuleConfigs[0].count)*WindowStyle.maxWidth,
            CGFloat(state.activeModuleConfigs.count)*WindowStyle.maxHeight)
    }
    
    public var environmentIPhoneSize: CGSize {
        return .init(width: .infinity,
                     height: (state.geometry?.localFrame.height ?? ContainerConfig.iPhoneScreenHeight))
    }
    
    var maxWidth: Int {
        Array(state.activeModuleConfigs.map { $0.count }).max() ?? 0
    }
    
    var maxHeight: Int {
        state.activeModuleConfigs.count
    }
    
    var totalWindows: Int {
        state.activeModuleConfigs.flatMap { group in group.map { $0 } }.count
    }
    
    var nonIPhoneHStackSpacing: CGFloat {
        if maxWidth < 2 {
            return 0.0
        } else {
            return AppStyle.Padding.level4
        }
    }
}
