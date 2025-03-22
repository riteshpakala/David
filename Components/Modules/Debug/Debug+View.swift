import Granite
import SwiftUI

extension Debug: View {
    public var view: some View {
        VStack {
            Spacer()
            Button(action: {
//                print("{TEST} \(holdings.state.strategy?.investments.count)")
                service.center.debug.send()
            }) {
                GraniteButton(.text("Test"),
                              selected: true,
                              size: .init(16),
                              padding: .init(0,
                                             Brand.Padding.xMedium,
                                             Brand.Padding.xSmall,
                                             Brand.Padding.small))
            }
            .buttonStyle(PlainButtonStyle())
            
            Button(action: {
                service.center.getMovers.send(StockService.GetMovers.Meta())
            }) {
                GraniteButton(.text("Test Network"),
                              selected: true,
                              size: .init(16),
                              padding: .init(0,
                                             Brand.Padding.xMedium,
                                             Brand.Padding.xSmall,
                                             Brand.Padding.small))
            }
            .buttonStyle(PlainButtonStyle())
            Spacer()
        }
    }
}
