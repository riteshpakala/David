//
//  StrategyView.swift
//  Stoic
//
//  Created by Ritesh Pakala Rao on 2/18/23.
//

import Foundation
import Granite
import SwiftUI
import GraniteUI
import DavidKit

struct StrategyView: View {
    @Environment(\.graniteRouter) var router
    
    @GraniteAction<Stock> var buy
    @GraniteAction<Stock> var sell
    @GraniteAction<Stock> var close
    
    var isPreview: Bool = false
    
    var strategy: Strategy?
    
    var columns: [GridItem] {
        [
            GridItem(.flexible()),
        ]
    }
    
    var investmentData: [Investment] {
        strategy?.investments ?? []
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(investmentData, id: \.self) { item in
                    
                    VStack {
                        header(item)
                            .padding(.top, Brand.Padding.medium)
                            .padding(.leading, Brand.Padding.xMedium)
                            .padding(.trailing, Brand.Padding.xMedium)
                            .padding(.bottom, Brand.Padding.medium)
                            
                        PaddingVertical(Brand.Padding.xSmall)
                        
                        info(item)
                        
                    }.background(GradientView(colors: [Brand.Colors.marbleV2,
                                                       Brand.Colors.marble],
                                              direction: .topLeading)
                                    .shadow(color: Color.black, radius: 6.0, x: 2.0, y: 3.0))
                                    .padding(.bottom, Brand.Padding.small)
                                    .padding(.top, Brand.Padding.medium)
                                    .opacity(item.isClosed ? 0.5 : 1.0)
                }
            }
            .padding(.horizontal, Brand.Padding.medium)
        }.graniteNavigationDestination(title: .init("\(strategy?.startDate.asString ?? "")"),
                                       font: Fonts.live(.headline, .bold))
    }
    
    public func header(_ item: Investment) -> some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(alignment: .leading) {
                GraniteText("company name",
                            Brand.Colors.black,
                            .headline,
                            .bold)
                
                Text("\(item.stock.name)")
                    .lineLimit(1)
                    .foregroundColor(Brand.Colors.black)
                    .font(Fonts.live(.subheadline, .regular))
                    .padding(.leading, 2)
//                GraniteText("\(item.stock.name)",
//                            Brand.Colors.black,
//                            .subheadline,
//                            .regular,
//                            .leading,
//                            addSpacers: false)
                
                if item.isClosed == false {
                    GraniteText("opened",
                                Brand.Colors.black,
                                .headline,
                                .bold)
                    .padding(.top, Brand.Padding.small)
                    
                    GraniteText(.init(item.openedDate.asStringWithTime),
                                Brand.Colors.black,
                                .subheadline,
                                .regular)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                GraniteText(.init(item.stock.ticker.uppercased()),
                            .title3,
                            .bold,
                            .trailing,
                            style: .init(gradient: [Color.black.opacity(0.75),
                                                    Color.black.opacity(0.36)]),
                            addSpacers: false)
                    .padding(.top, Brand.Padding.small)
                    .route(title: item.stock.display) {
                        AssetDetail(stock: item.stock)
                    } with: { router }
                
                Spacer()
                
                if isPreview == false,
                   item.isClosed == false {
                    HStack(spacing: Brand.Padding.xMedium) {
                        
                        Button(action: {
                            GraniteHaptic.light.invoke()
                            close.perform(item.stock)
                        }) {
                            GraniteText("close",
                                        Brand.Colors.redBurn,
                                        .headline,
                                        .bold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 6)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .foregroundColor(Brand.Colors.marble)
                        )
                        .shadow(color: Color.black,
                                radius: 0.5, x: 0.5, y: 0.5)
                        .padding(.trailing, 2)
                        
                        Button(action: {
                            GraniteHaptic.light.invoke()
                            buy.perform(item.stock)
                        }) {
                            GraniteButton(.imageSystem("plus.square"),
                                          selected: true,
                                          size: .init(16),
                                          padding: .init(0,
                                                         0,
                                                         0,
                                                         0))
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.trailing, Brand.Padding.medium8)
                        
                        Button(action: {
                            GraniteHaptic.light.invoke()
                            sell.perform(item.stock)
                        }) {
                            GraniteButton(.imageSystem("minus.square"),
                                          selected: true,
                                          size: .init(16),
                                          padding: .init(0,
                                                         0,
                                                         0,
                                                         0))
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.trailing, 2)
                    }
                }
                
            }
        }
    }
    
    public func info(_ item: Investment) -> some View {
        HStack(spacing: Brand.Padding.medium) {
            

            VStack(spacing: Brand.Padding.xSmall) {

                GraniteText(.init("$\(item.ownedValue.abbreviate)"),
                            .subheadline,
                            .bold,
                            .leading)
                    .lineLimit(1)
                    .shadow(color: .black,
                            radius: 1, x: 1.5, y: 1)
                
                GraniteText(.init("\(item.ownedShares)"),
                            .footnote,
                            .bold,
                            .leading)
                    .shadow(color: .black,
                            radius: 1, x: 1.5, y: 1)

                GraniteText("owned",
                            .footnote,
                            .regular,
                            .leading)
                            .shadow(color: .black,
                                    radius: 1, x: 1, y: 1)
            }
            .padding(.top, Brand.Padding.medium)
            .padding(.bottom, Brand.Padding.medium)
            .padding(.leading, Brand.Padding.medium)
            .padding(.trailing, Brand.Padding.medium9)
            .background(Brand.Colors.black
                        .opacity(0.57)
                        .cornerRadius(6.0)
                        .shadow(color: .black, radius: 2, x: 1, y: 2))
            .overlay(
                ZStack {
                    VStack {
                        HStack {
                            Spacer()
                            
                            Button {
                                item.exportBuyingHistory()
                            } label: {
                                Image(systemName: "square.and.arrow.up")
                                    .font(Fonts.live(.headline, .bold))
                                    .foregroundColor(Brand.Colors.white)
                            }.buttonStyle(PlainButtonStyle())
                        }
                        .padding(.trailing, Brand.Padding.medium)
                    }
                }
            )
            
            VStack(spacing: Brand.Padding.xSmall) {
                
                GraniteText(.init("$\(item.totalSoldValue.abbreviate)"),
                            .subheadline,
                            .bold,
                            .leading)
                    .lineLimit(1)
                    .shadow(color: .black,
                            radius: 1, x: 1.5, y: 1)
                
                GraniteText(.init("\(item.totalSoldShares)"),
                            .footnote,
                            .bold,
                            .leading)
                    .shadow(color: .black,
                            radius: 1, x: 1.5, y: 1)

                GraniteText("sold",
                            .footnote,
                            .regular,
                            .leading)
                            .shadow(color: .black,
                                    radius: 1, x: 1, y: 1)
            }
            .padding(.top, Brand.Padding.medium)
            .padding(.bottom, Brand.Padding.medium)
            .padding(.leading, Brand.Padding.medium)
            .padding(.trailing, Brand.Padding.medium9)
            .background(Brand.Colors.black
                            .opacity(0.27)
                            .cornerRadius(6.0)
                            .shadow(color: .black, radius: 2, x: 1, y: 2))
            .overlay(
                ZStack {
                    VStack {
                        HStack {
                            Spacer()
                            
                            Button {
                                item.exportSellingHistory()
                            } label: {
                                Image(systemName: "square.and.arrow.up")
                                    .font(Fonts.live(.headline, .bold))
                                    .foregroundColor(Brand.Colors.white)
                            }.buttonStyle(PlainButtonStyle())
                        }
                        .padding(.trailing, Brand.Padding.medium)
                    }
                }
            )
            
            
            VStack(spacing: Brand.Padding.xSmall) {
                
                GraniteText("\(item.profitValue < 0 ? "-" : "")$\(item.profitValue.abbreviate)",
                            .subheadline,
                            .bold,
                            .leading)
                    .lineLimit(1)
                    .shadow(color: .black,
                            radius: 1, x: 1.5, y: 1)
                                
                GraniteText("\(item.trades) trade\(item.trades > 1 ? "s" : "")",
                            .footnote,
                            .bold,
                            .leading)
                    .shadow(color: .black,
                            radius: 1, x: 1.5, y: 1)
                
                
                GraniteText("profit",//\(item.lastChangeDate.asString)",
                            .footnote,
                            .regular,
                            .leading)
                            .shadow(color: .black,
                                    radius: 1, x: 1, y: 1)
            }
            .padding(.top, Brand.Padding.medium)
            .padding(.bottom, Brand.Padding.medium)
            .padding(.leading, Brand.Padding.medium)
            .padding(.trailing, Brand.Padding.medium9)
            .background(item.statusColor
                            .opacity(0.57)
                            .cornerRadius(6.0)
                            .shadow(color: .black, radius: 2, x: 1, y: 2))
            
        }
        .padding(.leading, Brand.Padding.medium)
        .padding(.trailing, Brand.Padding.medium)
        .padding(.bottom, Brand.Padding.medium)
    }
}
