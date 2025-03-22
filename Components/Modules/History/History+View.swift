import Granite
import GraniteUI
import SwiftUI

extension History: View {
    public var view: some View {
        ZStack {
            VStack {
                HStack {
                    GraniteText("history",
                                .headline)
                        .padding(.leading, Brand.Padding.medium)
                    
                    Spacer()
                }.padding(.top, Brand.Padding.medium)
                
                ScrollView {
                    LazyVStack {
                        
                        ForEach(service.center.state.pastStrategies) { strategy in
                            strategyDetailView(strategy)
                                .route(title: "\(strategy.age) days") {
                                    StrategyView(isPreview: true, strategy: strategy)
                                } with: { router }
                        }
                        
                        Spacer()
                    }
                }
                .overlayIf(service.center.state.pastStrategies.isEmpty) {
                    GraniteDisclaimerView("View your past trading strategies here. When you reset, they will move over here allowing you to compare and improve on future investments.")
                }
            }
            
            if service.isLoaded == false {
                VStack(alignment: .center) {
                    ProgressView()
                }
            }
        }
        .padding(.bottom, .layer1)
    }
    
    func strategyDetailView(_ strategy: Strategy) -> some View {
        VStack {
            VStack {
                HStack(spacing: Brand.Padding.medium) {
                    VStack(alignment: .leading) {
                        HStack(spacing: Brand.Padding.small) {
                            GraniteText("date:",
                                        Brand.Colors.black,
                                        .headline,
                                        .bold)
                            
                            GraniteText("\(strategy.startDate.asString)",
                                        Brand.Colors.black,
                                        .subheadline,
                                        .regular,
                                        .leading)
                        }
                        
                        HStack(spacing: Brand.Padding.small) {
                            GraniteText("stocks:",
                                        Brand.Colors.black,
                                        .headline,
                                        .bold)
                            
                            GraniteText("\(strategy.investments.count)",
                                        Brand.Colors.black,
                                        .subheadline,
                                        .regular,
                                        .leading)
                        }
                        
                        HStack(spacing: Brand.Padding.small) {
                            GraniteText("trades:",
                                        Brand.Colors.black,
                                        .headline,
                                        .bold)
                            
                            GraniteText("\(strategy.trades)",
                                        Brand.Colors.black,
                                        .subheadline,
                                        .regular,
                                        .leading)
                        }
                        
                        Button(action: {
                            GraniteHaptic.light.invoke()
                            
                            service
                                .center
                                .remove
                                .send(HoldingsService
                                    .Center
                                    .Remove
                                    .Meta(id: strategy.id))
                        }) {
                            GraniteText("remove",
                                        Brand.Colors.black,
                                        .headline,
                                        .bold,
                                        .leading,
                                        addSpacers: false)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .foregroundColor(Brand.Colors.marble)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .shadow(color: Color.black,
                                radius: 0.5, x: 0.5, y: 0.5)
                        Spacer()
                    }
                    
                    VStack {
                        VStack(spacing: Brand.Padding.xSmall) {
                            
                            GraniteText("change: \(strategy.closingChange.display)%",
                                        .subheadline,
                                        .bold,
                                        .leading)
                            .lineLimit(1)
                            .shadow(color: .black,
                                    radius: 2, x: 2, y: 2)
                            
                            GraniteText("closing: $\(strategy.closingValue.abbreviate)",
                                        .footnote,
                                        .bold,
                                        .leading)
                            .shadow(color: .black,
                                    radius: 2, x: 2, y: 2)
                            
                            
                            GraniteText("wallet: $\(strategy.startingValue.abbreviate)",
                                        .footnote,
                                        .regular,
                                        .leading)
                            .shadow(color: .black,
                                    radius: 2, x: 2, y: 2)
                        }
                        .padding(.top, Brand.Padding.medium)
                        .padding(.bottom, Brand.Padding.medium)
                        .padding(.leading, Brand.Padding.medium)
                        .padding(.trailing, Brand.Padding.medium)
                        .background(strategy.colorClosingScheme
                            .opacity(0.57)
                            .cornerRadius(6.0)
                            .shadow(color: .black, radius: 4, x: 1, y: 2))
                        Spacer()
                    }
                }
                .padding(.horizontal, Brand.Padding.medium)
                
                Spacer()
                
                ScrollView(.horizontal) {
                    HStack(spacing: Brand.Padding.small) {
                        Spacer().frame(width: Brand.Padding.small)
                        
                        ForEach(strategy.investments, id: \.self) { item in
                            GraniteText(.init(item.stock.ticker.uppercased()),
                                        .title3,
                                        .bold,
                                        .center)
                            .padding(.vertical, Brand.Padding.small)
                            .padding(.horizontal, Brand.Padding.medium8)
                            
                            .background(item.statusColor
                                            .opacity(0.57)
                                            .cornerRadius(6.0)
                                            .shadow(color: .black, radius: 2, x: 1, y: 2))
                            .route(title: item.stock.display) {
                                AssetDetail(stock: item.stock)
                            } with: { router }
                        }
                    }
                    .padding(.vertical, Brand.Padding.small)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, Brand.Padding.xSmall)
            }
            .padding(.vertical, Brand.Padding.medium)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 180)
        .background(GradientView(colors: [Brand.Colors.marbleV2,
                                           Brand.Colors.marble],
                                  direction: .topLeading)
                        .shadow(color: Color.black, radius: 6.0, x: 2.0, y: 3.0))
                        .padding(.bottom, Brand.Padding.small)
                        .padding(.top, Brand.Padding.medium)
        .padding(.horizontal, Brand.Padding.medium)
    }
}
