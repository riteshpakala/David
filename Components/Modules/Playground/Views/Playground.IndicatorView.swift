//
//  Playground.IndicatorView.swift
//  Stoic (iOS)
//
//  Created by Ritesh Pakala on 6/2/23.
//

import Foundation
import SwiftUI
import Granite
import GraniteUI

extension Playground {
    //MARK: -- indicatorSelector
    var indicatorSelector: some View {
        ZStack {
            VStack {
                HStack {
                    GraniteText("select 2 training indicators",
                                .subheadline,
                                .regular,
                                .leading,
                                addSpacers: false)
                    .addInfoIcon(text: "2 indicators are calculated relative to the tonal date range picked. Generated for each day upon insertion into the model for prediction.")
                    .shadow(color: .black, radius: 2, x: 1, y: 1)
                    
                    Spacer()
                    
                    GraniteText("\(state.selectedIndicators.count)/2",
                                state.selectedIndicators.count >= 2 ? Brand.Colors.green : Brand.Colors.red,
                                .subheadline,
                                .regular,
                                .trailing,
                                addSpacers: false)
                    .shadow(color: .black, radius: 2, x: 1, y: 1)
                }
                .padding(.leading, Brand.Padding.medium)
                .padding(.trailing, Brand.Padding.medium)
                .padding(.bottom, Brand.Padding.small)
                
                ScrollView {
                    Spacer().frame(height: Brand.Padding.medium)
                    
                    LazyVGrid(columns: columns2, spacing: Brand.Padding.large) {
                        ForEach(state.indicatorChoices, id: \.self) { indicator in
                            
                            VStack {
                                backgroundColorForIndicator(indicator).overlay(
                                    GraniteText(.init(indicator.rawValue),
                                                indicatorIsSelected(indicator) ? Brand.Colors.black : Brand.Colors.white,
                                                .subheadline,
                                                .regular)
                                    .padding(.horizontal, 8)
                                )
                                .frame(maxWidth: .infinity,
                                       minHeight: 75,
                                       maxHeight: 120,
                                       alignment: .center)
                                .cornerRadius(8)
                                .shadow(color: .black, radius: 2, x: 2, y: 2)
                                .modifier(TapAndLongPressModifier(tapAction: {
                                    GraniteHaptic.light.invoke()
                                    //TODO: move to reducer
                                    if state.selectedIndicators.contains(indicator) {
                                        center.state.selectedIndicators.removeAll(where: { $0 == indicator })
                                    } else if state.selectedIndicators.count >= 2 {
                                        _ = center.state.selectedIndicators.popLast()
                                        center.state.selectedIndicators.append(indicator)
                                    } else {
                                        center.state.selectedIndicators.append(indicator)
                                    }
                                }))
                            }
                        }
                        
                    }
                    .padding(.horizontal, Brand.Padding.large)
                    
                    Spacer().frame(height: Brand.Padding.large)
                }
                .background(GradientView(colors: [Brand.Colors.marbleV2,
                                                   Brand.Colors.marble],
                                          direction: .topLeading)
                                .shadow(color: Color.black, radius: 2.0, x: 2.0, y: 3.0)
                                .padding(.horizontal, Brand.Padding.medium)
                )
            }
        }.clipped()
    }
}

extension Playground {
    //MARK: -- indicatorOutputView
    var indicatorOutputView: some View {
        ZStack {
            VStack {
                HStack {
                    GraniteText("select what to forecast",
                                .subheadline,
                                .regular,
                                .leading,
                                addSpacers: false)
                    .addInfoIcon(text: "6 indicators are calculated relative to the tonal date range picked. Generated for each day upon insertion into the model for prediction.")
                    .shadow(color: .black, radius: 2, x: 1, y: 1)
                    
                    Spacer()
                }
                .padding(.horizontal, Brand.Padding.medium)
                
                LazyVGrid(columns: columns, spacing: Brand.Padding.large) {
                    ForEach(state.outputChoices, id: \.self) { output in
                        
                        VStack {
                            backgroundColorForOutput(output).overlay(
                                GraniteText(.init(output.rawValue),
                                            outputSelected(output) ? Brand.Colors.black : Brand.Colors.white,
                                            .subheadline,
                                            .regular)
                            )
                            .frame(maxWidth: .infinity,
                                   minHeight: 75,
                                   maxHeight: 120,
                                   alignment: .center)
                            .cornerRadius(8)
                            .shadow(color: .black, radius: 2, x: 2, y: 2)
                            .modifier(TapAndLongPressModifier(tapAction: {
                                GraniteHaptic.light.invoke()
                                center.$state.binding.selectedOutput.wrappedValue = output
                            }))
                        }
                    }
                }
                .frame(height: 104)
                .padding(.horizontal, Brand.Padding.large)
                .background(GradientView(colors: [Brand.Colors.marbleV2,
                                                   Brand.Colors.marble],
                                          direction: .topLeading)
                                .shadow(color: Color.black, radius: 2.0, x: 2.0, y: 3.0)
                                .padding(.horizontal, Brand.Padding.medium)
                )
            }
            
        }.clipped()
    }
    
}
