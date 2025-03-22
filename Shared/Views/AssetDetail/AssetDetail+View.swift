import Granite
import SwiftUI
import GraniteUI

extension AssetDetail {
    static var sheetId: String = "nyc.stoic.Bullish.AssetDetail"
    
    public var body: some View {
        Group {
            switch kind {
            case .expanded:
                expanded
            default:
                preview
            }
        }
        .onAppear {
            guard let stock = self.security else { return }
            
            if self.stocks.isEmpty {
                //TODO:
                service.center.getHistory.send(StockService.GetHistory.Meta(security: stock))
            }
        }
    }
    
    public var preview: some View {
        VStack {
            GraphPage(someModel: plotData)
        }
        .frame(maxWidth: .infinity,
               minHeight: ContainerConfig.iPhoneScreenHeight / 3,
               maxHeight: ContainerConfig.iPhoneScreenHeight / 3)
    }
    public var expanded: some View {
        VStack {
            
            GraphPage(someModel: plotData)
            
            PaddingVertical()
            
            //Indicators
            ZStack {
                GraphPage(someModel: plotDataStochastics.percentK).opacity(0.75)
                
                GraphPage(someModel: plotDataStochastics.percentD)
            }.frame(maxWidth: .infinity,
                    maxHeight: 120)
            .padding(.top, Brand.Padding.medium)
            .padding(.trailing, Brand.Padding.medium)
            .padding(.leading, Brand.Padding.medium)
            .padding(.bottom, Brand.Padding.medium)
        }
        .graniteNavigationDestination(title: .init("\(stock.display)"),
                                      font: Fonts.live(.headline, .bold)) {
            Button(action: {
                GraniteHaptic.light.invoke()
                
                print("\(self.stocks.suffix(12).map { $0.asTimeSeriesData })")
                
                guard holdingsService.state.isStrategyLive else {
                    ModalService
                        .shared
                        .presentModal(GraniteAlertView(message: .init("You must create a \"new strategy\" to begin investing.")) {
                        
                        GraniteAlertAction(title: "done")
                    })
                    
                    return
                }
                
                
                ModalService
                    .shared
                    .presentModal(GraniteAlertView(mode: .sheet) {
                    if let lastStock = stocks.last {
                        GraniteAlertAction {
                            OrderView(lastStock: stocks.suffix(5).last ?? lastStock,
                                      currentHoldings: holdingsService.state.wallet.current, currentlyOwned: ownedShares)
                                .attach(holdingsService.center.order, at: \.placeOrder)
                                .frame(height: 160)
                                .padding(.horizontal, Brand.Padding.medium)
                        }
                    }

                    GraniteAlertAction(title: "Cancel")
                })
            }) {
                GraniteButton(.imageSystem("plus"),
                              selected: true,
                              size: .init(14),
                              padding: .init(0,
                                             0,
                                             0,
                                             Brand.Padding.small))
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}
