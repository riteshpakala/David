//
//  WindowComponent.swift
//
//  Created by Ritesh Pakala Rao on 3/31/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Granite
import SwiftUI
import Combine

struct Module: GraniteComponent {
    
    @Command var center: Center
    
    init(config: ModuleConfig) {
        center.state.config = config
    }
}

//extension GraniteComponent {
//    public var showEmptyState: some View {
//        Passthrough {
//            if self.isDependancyEmpty {
//                GraniteEmptyComponent(state: .init(self.emptyText))
//                    .payload(self.emptyPayload)
//            } else {
//                self
//            }
//        }
//    }
//}
