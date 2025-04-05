import Granite
import GraniteUI
import SwiftUI
import DavidKit

extension AssetSection: View {
    var assetData: [Security] {
        service.state.movers.get(state.securityType, category: state.context.categoryType)
    }
    
    var date: Date {
        assetData.first?.date ?? .today
    }
    
    public var view: some View {
        VStack(alignment: .leading) {
            GraniteText(.init("\(service.state.testString) - empty: \(assetData.isEmpty)"),
                        Brand.Colors.marble,
                        .footnote,
                        .regular,
                        .leading)
                        .padding(.top, Brand.Padding.medium)
                        .padding(.leading, Brand.Padding.medium)
                        .padding(.bottom, Brand.Padding.small)
            
            GraniteText("last updated: \(date.asStringWithTime)",
                        Brand.Colors.marble,
                        .footnote,
                        .regular,
                        .leading)
                        .padding(.top, Brand.Padding.medium)
                        .padding(.leading, Brand.Padding.medium)
                        .padding(.bottom, Brand.Padding.small)
            HStack {
                if center.toggleTitle {
                    GraniteToggle(options: .init(center.toggleTitleLabels,
                                                 padding: Brand.Padding.medium), onToggle: { index in
                        //TODO:
                        //set(\.toggleTitleIndex, value: index)
                    })
                    .padding(.leading, Brand.Padding.small)
                } else {
                    GraniteText(state.context.label, .headline, .bold)
                }
                Spacer()
                //TODO: crypto option
//                GraniteToggle(options: .init(["stock", "crypto"],
//                                             padding: Brand.Padding.medium), onToggle: { index in
//                    //TODO:
//                    //set(\.securityType, value: index == 0 ? .stock : .crypto)
//                })
                
//                #if DEBUG
//                GraniteButtonComponent(state: .init(.image("refresh_icon"),
//                                                    colors: [Brand.Colors.yellow,
//                                                             Brand.Colors.purple],
//                                                    selected: true,
//                                                    size: .init(16),
//                                                    padding: .init(0,
//                                                                   Brand.Padding.xMedium,
//                                                                   Brand.Padding.xSmall,
//                                                                   Brand.Padding.small),
//                                                    action: {
//                                                        GraniteHaptic.light.invoke()
//                                                        sendEvent(AssetSectionEvents.Refresh(sync: true))
//                                                    }))
//                #endif
                
                Button(action: {
                    service.center.getMovers.send(StockService.GetMovers.Meta())
                }) {
                    GraniteButton(.image("refresh_icon"),
                                  selected: true,
                                  size: .init(16),
                                  padding: .init(0,
                                                 Brand.Padding.xMedium,
                                                 Brand.Padding.xSmall,
                                                 Brand.Padding.small))
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.leading, Brand.Padding.medium)
            .padding(.trailing, Brand.Padding.medium)
            VStack(alignment: .leading, spacing: Brand.Padding.medium) {
                //TODO: switch asset data based on window type
                AssetGridView(type: state.context.assetGridType,
                              context: state.context,
                              assetData: assetData,
                              leadingPadding: Brand.Padding.medium)
            }
        }
    }
}
