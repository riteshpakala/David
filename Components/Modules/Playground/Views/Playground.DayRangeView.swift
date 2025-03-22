//
//  Playground.DayRangeView.swift
//  Stoic (iOS)
//
//  Created by Ritesh Pakala on 6/2/23.
//

import Foundation
import SwiftUI
import Granite
import GraniteUI

extension Playground {
    //MARK: -- rangeSelector
    var rangeSelector: some View {
        ZStack {
            
            VStack {
                VStack {
                    HStack {
                        GraniteText("stock's tonal date range",
                                    .subheadline,
                                    .regular)
                        .addInfoIcon(text: "Specify the length for the range of dates to train the model.")
                        
                        Spacer()
                        
                        GraniteText("\(state.days) days",
                                    Brand.Colors.yellow,
                                    .subheadline,
                                    .regular,
                                    .trailing,
                                    addSpacers: false)
                        .shadow(color: .black, radius: 2, x: 1, y: 1)
                    }
                    
                    ValueSlider(value: center.$state.binding.daysPercent,
                                onEditingChanged: { changed in
                        if changed {
                        } else {
                            DispatchQueue.main.async {
                                GraniteHaptic.light.invoke()
                                center.getRanges.send(Playground.GetRanges.Meta(stocks: state.stocks))
                            }
                        }
                    })
                    .frame(height: 32) //*2 on mac
                    .valueSliderStyle(
                        HorizontalValueSliderStyle(
                            track: HorizontalValueTrack(
                                view: LinearGradient(
                                    gradient: Gradient(colors: [Brand.Colors.marble, Brand.Colors.redBurn]),
                                    startPoint: .leading,
                                    endPoint: .trailing),
                                mask: RoundedRectangle(cornerRadius: 3)
                            )
                            .frame(height: 32)
                            .cornerRadius(6),
                            thumb: RoundedRectangle(cornerRadius: 4).foregroundColor(Brand.Colors.white),
                            thumbSize: CGSize(width: 6, height: 24)
                        )
                    )
                    .shadow(color: Color.black, radius: 4.0, x: 2.0, y: 2.0)
                    
                    //                    BasicSliderComponent(
                    //                        state: inject(\.toneDependency,
                    //                                         target: \.tone.find.sliderDays))
                    //                        .listen(to: command)
                    //                        .padding(.top, Brand.Padding.medium)
                    //                        .padding(.bottom, Brand.Padding.medium)
                    //
                    //                    GraniteText("\(command.center.daysSelected) days", .subheadline, .regular)
                }
                .padding(.bottom, Brand.Padding.medium)
                .padding(.leading, Brand.Padding.medium)
                .padding(.trailing, Brand.Padding.medium)
                .transition(.move(edge: .bottom))
                
                VStack {
                    HStack {
                        GraniteText("select a date range",
                                    .subheadline,
                                    .regular)
                        .addInfoIcon(text: "These are \"tones\" of the market of the selected Stock. Various dates in the past shared similarities with the present. History tends to repeat itself.")
                        .shadow(color: .black, radius: 2, x: 1, y: 1)
                        
                        Spacer()
                    }
                }
                .padding(.leading, Brand.Padding.medium)
                .padding(.trailing, Brand.Padding.medium)
                .padding(.bottom, Brand.Padding.small)
                .padding(.top, Brand.Padding.small)
                
                ScrollView {
                    
                    Spacer().frame(height: Brand.Padding.medium)
                    
                    LazyVGrid(columns: columns, spacing: Brand.Padding.large) {
                        ForEach(state.tonalRanges, id: \.self) { tonalRangeIndex in
                            
                            VStack {
                                backgroundColorForRange(tonalRangeIndex).overlay(
                                    GraniteText(.init(tonalRangeIndex.dateInfoShortDisplay),
                                                rangeIsSelected(tonalRangeIndex) ? Brand.Colors.black : Brand.Colors.white,
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
                                    center.$state.binding.selectedTonalRange.wrappedValue = tonalRangeIndex
                                }))
                                
                                GraniteText(.init(tonalRangeIndex.avgSimilarityDisplay),
                                            tonalRangeIndex.avgSimilarityColor,
                                            .subheadline,
                                            .regular,
                                            style: .init(gradient: [Color.black,
                                                                    Color.black.opacity(0.75)]))
                            }
                        }
                    }
                    .padding(.horizontal, Brand.Padding.large)
                    
                    Spacer().frame(height: Brand.Padding.large)
                    
                }.background(GradientView(colors: [Brand.Colors.marbleV2,
                                                   Brand.Colors.marble],
                                          direction: .topLeading)
                                .shadow(color: Color.black, radius: 2.0, x: 2.0, y: 3.0)
                                .padding(.horizontal, Brand.Padding.medium)
                )
            }
            .padding(.bottom, Brand.Padding.medium)
        }.clipped()
    }
}
