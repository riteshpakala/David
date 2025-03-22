import Granite
import SwiftUI
import GraniteUI

extension Portfolio: View {
    public var view: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer().frame(height: 36)
                    .padding(Brand.Padding.medium)
                
                PaddingVertical()
                
                portfolioHeader
                    .padding(.horizontal, Brand.Padding.medium)
                
                wallet
                    .padding(.horizontal, Brand.Padding.medium)
                    .padding(.bottom, Brand.Padding.small)
                
                PaddingVertical()
                
                investments
                    .fitToContainer()
                    .overlayIf(service.center.state.isStrategyLive == false) {
                        GraniteDisclaimerView("This is where your investments will be displayed during your current trading strategy.")
                    }
                    .overlayIf(service.state.isSyncing) {
                        syncingView
                    }
            }
            
            AssetSearch()
        }
        .padding(.bottom, .layer1)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

extension Portfolio {
    var investments: some View {
        VStack {
            HStack {
                GraniteText("investments")
                    .padding(.leading, Brand.Padding.medium)
                
                Spacer()
                
                if canSync {
                    Button(service.center.sync) {
                        
                        GraniteButton("sync", padding: .init(Brand.Padding.medium, 0))
                            .addInfoIcon(text: "Your investments may be out of date. Use this to update your stocks to the most recent.", spacing: 4, direction: .leading)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }.padding(.top, Brand.Padding.medium)
            
            StrategyView(strategy: service.state.strategy)
                .attach({ stock in
                    showOrderScreen(stock, buy: true)
                }, at: \.buy)
                .attach({ stock in
                    showOrderScreen(stock, sell: true)
                }, at: \.sell)
                .attach({ stock in
                    showOrderScreen(stock, close: true)
                }, at: \.close)
                .overlayIf(service.center.state.hasInvestments == false) {
                    
                    GraniteDisclaimerView("Search for a stock and make a new investment for it to appear here.")
                }
        }
    }
}

extension Portfolio {
    func showOrderScreen(_ stock: Stock,
                         buy: Bool = false,
                         sell: Bool = false,
                         close: Bool = false) {
        guard let stocks = stockService.state.stocks[stock.ticker]?[SecurityInterval.day.rawValue] else {
            return
        }
        let ownedShares: Double = service.state.strategy?.investmentFor(stock)?.ownedShares ?? 0.0
        
        ModalService
            .shared
            .present(GraniteAlertView(title: close ? .init("This will sell all shares. You will have to repurchase this Stock via search") : nil,
                                              titleFont: close ? Fonts.live(.subheadline, .bold) : nil,
                                              mode: .sheet) {
            if let lastStock = stocks.last, close == false {
                GraniteAlertAction {
                    OrderView(lastStock: stocks.suffix(5).last ?? lastStock,
                              currentHoldings: service.state.wallet.current,
                              currentlyOwned: ownedShares,
                              isSell: sell)
                    .attach({ payload in
                        if buy {
                            service.center.order.send(payload)
                        } else if sell {
                            service.center.sell.send(payload)
                            
                        }
                    }, at: \.placeOrder)
                        .frame(height: 160)
                        .padding(.horizontal, Brand.Padding.medium)
                }
            } else if close {
                GraniteAlertAction {
                    Button {
                        service.center.close.send(HoldingsService.Center.Close.Meta(stock: stock))
                        ModalService
                            .shared.dismiss()
                    } label: {
                        
                        GraniteText("Close", Brand.Colors.redBurn, .headline, .bold)
                    }
                }
            }

            GraniteAlertAction(title: "Cancel")
        })
    }
}


extension Portfolio {
    var portfolioHeader: some View {
        VStack {
            HStack(spacing: 0) {
                
                if service.state.isStrategyLive {
                    GraniteText(.init(service.state.strategy?.ageDisplay ?? ""),
                                .subheadline,
                                .bold,
                                style: .init(gradient: [Brand.Colors.black.opacity(0.75),
                                                        Brand.Colors.black.opacity(0.36)]))
                    .padding(.top, Brand.Padding.medium)
                    .padding(.bottom, Brand.Padding.medium)
                }
                
                Spacer()
                
                GraniteTimerView()
                    .padding(.top, Brand.Padding.medium)
                    .padding(.bottom, Brand.Padding.medium)
            }
            .padding(.top, service.state.isStrategyLive ? 2 : 0)
            .padding(.leading, Brand.Padding.medium)
            .padding(.trailing, Brand.Padding.medium)
            
            //User details
            VStack(spacing: Brand.Padding.medium) {
                
                
                if service.state.isStrategyLive {
                    
                    GraniteText(service.state.currentChangeDisplay,
                                service.state.colorScheme,
                                .title2,
                                .bold)
                    .padding(.horizontal, 8)
                    .applyGradient(selected: true,
                                   colors: [Brand.Colors.marbleV2.opacity(0.66),
                                            Brand.Colors.marble],
                                   shadow1: (0, 0.5, 0.5),
                                   shadow2: (0, 0.5, 0.5))
                    
//                    GraniteText(.init("$\((service.state.value).display)"),
//                                service.state.colorScheme,
//                                .headline,
//                                .bold)
                    
                } else {
                    Button(action: {
                        GraniteHaptic.light.invoke()
                        service.center.start.send()
                    }) {
                        GraniteText("create new strategy",
                                    .headline,
                                    .bold)
                        .frame(width: 200,
                               height: 24)
                        .applyGradient(selected: true,
                                       colors: [Brand.Colors.marbleV2.opacity(0.66),
                                                Brand.Colors.marble])
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.leading, Brand.Padding.medium)
            .padding(.trailing, Brand.Padding.medium)
            .padding(.bottom, Brand.Padding.medium)
            .padding(.top, Brand.Padding.medium)
            
            
            HStack(spacing: 0) {
                
                GraniteText("\(Date.nextTradingDay.simple != Date.today.simple ? "next " : "")trading day: \(Date.nextTradingDay.asString)",
                            .subheadline,
                            .bold,
                            .leading,
                            style: .init(gradient: [Brand.Colors.black.opacity(0.75),
                                                    Brand.Colors.black.opacity(0.36)]))
                    .padding(.top, Brand.Padding.medium)
                    .padding(.bottom, Brand.Padding.medium)
                
                
                if service.state.isStrategyLive {
                    Button(service.center.reset) {
                        GraniteText("end",
                                    Brand.Colors.redBurn,
                                    .title3,
                                    .bold)
                        .padding(.top, Brand.Padding.medium)
                        .padding(.bottom, Brand.Padding.medium)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                }
                
                
            }
            .padding(.leading, Brand.Padding.medium)
            .padding(.trailing, Brand.Padding.medium)
            
        }
        .frame(maxWidth: .infinity)
        .shadow(color: Color.black.opacity(0.75), radius: 1.0, x: 1.0, y: 1.0)
        .background(GradientView(direction: .topLeading)
                        .shadow(color: Color.black, radius: 8.0, x: 3.0, y: 3.0))
        .padding(.top, Brand.Padding.medium)
        .padding(.bottom, Brand.Padding.medium)
    }
}
