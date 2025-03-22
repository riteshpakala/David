//
//  Environment+View.swift
//  Stoic
//
//  Created by Ritesh Pakala Rao on 12/20/22.
//


import Granite
import GraniteUI
import SwiftUI
import Combine

extension Container: View {
    var view: some View {
        GraniteScrollView(showsIndicators: false) {
            //Max Windows Height
            VStack(spacing: 0) {
                ForEach(0..<center.maxWidth, id: \.self) { col in
                    VStack(spacing: 0) {
                        
                        ForEach(0..<center.maxHeight, id: \.self) { row in
                            if row < state.activeModuleConfigs.count,
                               col < state.activeModuleConfigs[row].count,
                               state.activeModuleConfigs[row][col].kind != .unassigned {
                                
                                getWindow(row,
                                          col,
                                          state.activeModuleConfigs[row][col])
                                
                                if  ((row + 1) * (col + 1)) < center.totalWindows {
                                    PaddingVertical(Brand.Padding.small)
                                }
                            }
                        }
                    }.frame(minWidth: 0,
                            maxWidth: .infinity,
                            minHeight: center.environmentIPhoneSize.height,
                            idealHeight: center.environmentIPhoneSize.height,
                            maxHeight: center.environmentIPhoneSize.height,
                            alignment: .center)
                }
            }
        }
        .fitToContainer()
    }
}

extension Container {
    func getWindow(_ row: Int, _ col: Int, _ config: ModuleConfig) -> some View {
        return window(config)
    }
}

extension Container {
    func window(_ config: ModuleConfig) -> some View {
        let window = createWindow(config)
//            .border(state.route.isDebug ? Brand.Colors.red : .clear,
//                    width: state.route.isDebug ? 4.0 : 0.0)


        return window
    }

    func createWindow(_ config: ModuleConfig) -> some View {
        Group {
            switch config.kind {
            case .topVolume(let securityType),
                    .winners(let securityType),
                    .losers(let securityType),
                    .winnersAndLosers(let securityType):
                AssetSection(context: config.kind,
                             securityType)
            case .floor:
                Floor()
            case .portfolio:
                Portfolio()
            case .special:
                Special()
            case .debug:
                Debug()
            default:
                EmptyView()
            }
        }
    }
}


