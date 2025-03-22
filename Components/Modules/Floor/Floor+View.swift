import Granite
import SwiftUI

extension Floor: View {
    public var view: some View {
        VStack {
            HStack {
                GraniteText("floor",
                            .headline)
                    .padding(.leading, Brand.Padding.medium)
                
                Spacer()
            }.padding(.top, Brand.Padding.medium)
            
            GraniteScrollView {
                VStack {
                    ForEach(service.state.strategy?.investments ?? []) { investment in
                        AssetDetail(.preview, stock: investment.stock)
                        PaddingVertical()
                    }
                }
                
            }
            .fitToContainer()
            .overlayIf(service.center.state.hasInvestments == false) {
                GraniteDisclaimerView("This is the \"Floor\" view where you will be able to see your investments in a minimalistic graph view. Browsing daily changes easily.")
            }
        }
        .fitToContainer()
        .padding(.bottom, .layer1)
    }
    
    var text: some View {
        print("\(CFAbsoluteTimeGetCurrent()) -- \(service.state.strategy?.investments.count)")
        return EmptyView()
    }
}
