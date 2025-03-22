//
//  BootExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala Rao on 12/31/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
import Granite
import SwiftUI
import Combine

extension Container {
    struct DidAppear: GraniteReducer {
        typealias Center = Container.Center
        
        struct Meta: GranitePayload {
            let page: ContainerConfig.PageType
        }
        
        @Payload var meta: Meta?
        
        func reduce(state: inout Center.State) {
            let meta = self.meta ?? .init(page: state.config.kind)
            
            state.config = .init(kind: meta.page)
            
            let page: ContainerConfig.Page = state.config.kind.page
            
            var windowsConfig: [[ModuleConfig]] = []
            //
            var cols: [Int] = .init(repeating: 0, count: page.windows.first?.count ?? ContainerConfig.maxWindows.width.asInt)
            cols = cols.enumerated().map { $0.offset }
            //
            
            for row in 0..<min(page.windows.count, ContainerConfig.maxWindows.height.asInt) {
                var windowRowConfig: [ModuleConfig] = []
                
                for col in cols {
                    guard row < page.windows.count,
                          col < page.windows[row].count else { continue }
                    let config: ModuleConfig = .init(kind: page.windows[row][col],
                                                     index:
                                                        .init(x: col,
                                                              y: row)
                                                     )
                    
                    windowRowConfig.append(config)
                }
                
                guard windowRowConfig.isNotEmpty else { continue }
                windowsConfig.append(windowRowConfig)
            }
            
            state.activeModuleConfigs = windowsConfig
        }
    }
    
    struct ChangeTab: GraniteReducer {
        typealias Center = Container.Center
        
        struct Meta: GranitePayload {
            let page: ContainerConfig.PageType
        }
        
        @Payload var meta: Meta?
        
        func reduce(state: inout Center.State) {
            let meta = self.meta ?? .init(page: state.config.kind)
            
            state.config = .init(kind: meta.page)
            
            let page: ContainerConfig.Page = state.config.kind.page
            
            var windowsConfig: [[ModuleConfig]] = []
            //
            var cols: [Int] = .init(repeating: 0, count: page.windows.first?.count ?? ContainerConfig.maxWindows.width.asInt)
            cols = cols.enumerated().map { $0.offset }
            //
            
            for row in 0..<min(page.windows.count, ContainerConfig.maxWindows.height.asInt) {
                var windowRowConfig: [ModuleConfig] = []
                
                for col in cols {
                    guard row < page.windows.count,
                          col < page.windows[row].count else { continue }
                    let config: ModuleConfig = .init(kind: page.windows[row][col],
                                                     index:
                                                        .init(x: col,
                                                              y: row)
                                                     )
                    
                    windowRowConfig.append(config)
                }
                
                guard windowRowConfig.isNotEmpty else { continue }
                windowsConfig.append(windowRowConfig)
            }
            
            state.activeModuleConfigs = windowsConfig
        }
    }
}
