//
//  PlaygroundPredictView.swift
//  Stoic (iOS)
//
//  Created by Ritesh Pakala on 6/2/23.
//

import Foundation
import SwiftUI
import Granite
import GraniteUI
import DavidKit

extension Playground {
    //MARK: -- predictView
    var predictView: some View {
        ZStack {
            VStack(spacing: 0) {
                GraniteText("disclaimer",
                            Brand.Colors.redBurn,
                            .footnote,
                            .bold)
                .padding(.horizontal, 6)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 3)
                        .foregroundColor(Brand.Colors.marble)
                )
                .shadow(color: Color.black,
                        radius: 0.5, x: 0.5, y: 0.5)
                .opacity(0.75)
                .disclaimer("Disclaimer: All predictions are NOT ABSOLUTE, Bullish is not responsible for decisions made outside of this application.\nThe pairings of tonality and indicators are unique with their security and the status quo.")
                
//                GraniteText("Disclaimer: All predictions are NOT ABSOLUTE.",
//                            .footnote,
//                            .bold)
//                    .padding(.horizontal, Brand.Padding.medium)
//                GraniteText("The pairings of tonality and indicators are unique with their security and the status quo.",
//                           .caption2,
//                           .regular)
//                        .opacity(0.57)
//                        .padding(.top, 8)
//                        .padding(.horizontal, Brand.Padding.large + 16)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Trading day: \(Date.nextTradingDay.asString)")
                        .font(Fonts.live(.subheadline, .bold))
                        .foregroundColor(Brand.Colors.white)
                        .padding(.horizontal, 8)
                        .padding(.top, 8)
                    Group {
                        Text("Change %")
                            .font(Fonts.live(.footnote, .bold))
                            .foregroundColor(Brand.Colors.purple) + Text(" for \"\(state.model?.context.rawValue.capitalized ?? "")\"")
                            .font(Fonts.live(.footnote, .bold))
                            .foregroundColor(Brand.Colors.white)
                    }
                    .padding(.horizontal, 8)
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        Text("\(center.state.prediction.percent)%")
                            .font(Fonts.live(.largeTitle, .bold))
                            .foregroundColor(state.predictionIsGainer ? Brand.Colors.green : (center.state.prediction == .zero ? Brand.Colors.yellow : Brand.Colors.red))
                    }
                    .padding(.horizontal, 8)
                    .padding(.bottom, 4)
                }
                .frame(width: 180,
                       height: 120)
                .applyGradient(selected: true,
                               colors: [Brand.Colors.marbleV2.opacity(0.66),
                                        Brand.Colors.marble])
                .padding(.bottom, 36)
                
                PointSlider(x: center.$state.binding.temperatureX,
                            y: center.$state.binding.temperatureY,
                            onEditingChanged: { changed in
                    if changed == false {
                        DispatchQueue.main.async {
                            GraniteHaptic.light.invoke()
                            center.$state.binding.predictionState.wrappedValue = .predicting
                            center.predict.send()
                        }
                    }
                })
                .frame(width: 192, height: 144)
                .pointSliderStyle(
                    RectangularPointSliderStyle(
                        track:
                            ZStack {
                                RadialGradient(gradient: Gradient(colors: [Brand.Colors.yellow, Brand.Colors.purple]), center: .center, startRadius: 1.0, endRadius: 300)
                                //                            LinearGradient(gradient: Gradient(colors: [Brand.Colors.yellow, Brand.Colors.purple]), startPoint: .leading, endPoint: .trailing)
                                //                            LinearGradient(gradient: Gradient(colors: [.white, .clear]), startPoint: .bottom, endPoint: .top).blendMode(.hardLight)
                            }
                            .cornerRadius(8),
                        thumbSize: CGSize(width: 36, height: 36)
                    )
                )
                .padding(.horizontal, Brand.Padding.large)
                .overlayIf(state.predictionState == .predicting) {
                    ZStack {
                        Brand.Colors.black.opacity(0.75)
                        ProgressView()
                            .scaleEffect(1.2)
                    }
                }
                .overlay(
                    sliderTip("movement",
                              subtitle: movementType,
                              infoMessage: "Your perceived volatility of the selected Stock. Increasing the intensity, will gather more data when deciding a Stock's momentum. If a Stock is currently volatile, lower day ranges might relate averages appropriately.")
                        .rotationEffect(.radians(-1.5708))
                        .offset(x: -144, y: 0)
                )
                
                sliderTip("tonality",
                          infoMessage: "The amount of data from the date of the most recent Stock of the selected tonal day range to use. Larger the number, more data is processed to calculate the selected indicators. Sometimes, less is more.",
                          flip: true,
                          width: 192)
                    .padding(.top, 16)
                    .padding(.bottom, 4)
                Text("\(variant1?.rawValue ?? "")")
                    .font(Fonts.live(.caption2, .bold))
                    .foregroundColor(Brand.Colors.yellow)
                    .padding(.bottom, 1)
                Text("\(variant2?.rawValue ?? "")")
                    .font(Fonts.live(.caption2, .bold))
                    .foregroundColor(Brand.Colors.yellow)
                
                Spacer()
            }
            .padding(.horizontal, Brand.Padding.medium)
        }
    }
    
    var movementType: String {
        if state.temperatureY > 0.85 {
            return "Very volatile"
        } else if state.temperatureY > 0.65 {
            return "Volatile"
        } else if state.temperatureY > 0.35 {
            return "Stable"
        } else {
            return "Very stable"
        }
    }
    
    var chosenIndicators: String {
        return "\(variant1?.rawValue ?? "")\n\(variant2?.rawValue ?? "")"
    }
    
    var variant1: StockServiceModels.Indicators.Variant? {
        guard state.selectedIndicators.count >= 2 else {
            return nil
        }
        
        return state.selectedIndicators[0]
    }
    
    var variant2: StockServiceModels.Indicators.Variant? {
        guard state.selectedIndicators.count >= 2 else {
            return nil
        }
        
        return state.selectedIndicators[1]
    }
}

extension Playground {
    func sliderTip(_ label: String,
                   subtitle: String? = nil,
                   infoMessage: String,
                   flip: Bool = false,
                   width: CGFloat = 144) -> some View {
        let days: Int = Tonality.scale(state.temperatureX).asInt
        return VStack(spacing: 4) {
            if !flip {
                
                if let subtitle = subtitle {
                    Text("\(subtitle)")
                        .font(Fonts.live(.caption2, .bold))
                        .foregroundColor(Brand.Colors.yellow)
                }
                Text(label)
                    .font(Fonts.live(.headline, .bold))
                    .foregroundColor(Brand.Colors.yellow)
                    .addInfoIcon(text: infoMessage)
                    .opacity(0.57)
                Text("\(state.temperatureY.asDouble.display)")
                    .font(Fonts.live(.footnote, .bold))
                    .foregroundColor(Brand.Colors.yellow)
            }
            
            HStack(spacing: 0) {
                Image(systemName: "chevron.left")
                    .resizable()
                    .frame(width: 8)
                    .aspectRatio(contentMode: .fit)
                    .font(Fonts.live(.caption2, .bold))
                    .foregroundColor(Brand.Colors.yellow)
                    .offset(x: 7)
                Rectangle()
                    .frame(width: width, height: 2)
                    .foregroundColor(Brand.Colors.yellow)
                    .opacity(0.57)
                Image(systemName: "chevron.right")
                    .resizable()
                    .frame(width: 8)
                    .aspectRatio(contentMode: .fit)
                    .font(Fonts.live(.caption2, .bold))
                    .foregroundColor(Brand.Colors.yellow)
                    .offset(x: -7)
            }.frame(height: 12)
            
            if flip {
                
                Text("\(days) day\(days > 1 ? "s" : "")")
                    .font(Fonts.live(.footnote, .bold))
                    .foregroundColor(Brand.Colors.yellow)
                Text(label)
                    .font(Fonts.live(.headline, .bold))
                    .foregroundColor(Brand.Colors.yellow)
                    .addInfoIcon(text: infoMessage)
                    .opacity(0.57)
                if let subtitle = subtitle {
                    Text("\(subtitle)")
                        .font(Fonts.live(.caption2, .bold))
                        .foregroundColor(Brand.Colors.yellow)
                        
                }
            }
        }
    }
}
