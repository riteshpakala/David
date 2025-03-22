//
//  ExperienceComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala Rao on 12/31/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import Granite
import SwiftUI
import Combine

struct Container: GraniteComponent {
    
    @Command var center: Center
    
    var layout: [GridItem] {
        .init(repeating: GridItem(.flexible()), count: center.maxWidth)
    }
    
    init(page: ContainerConfig.PageType = .home) {
        center.state.config = .init(kind: page)
        
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
        
        center.state.activeModuleConfigs = windowsConfig
    }
}
