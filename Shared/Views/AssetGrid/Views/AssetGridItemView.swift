import Granite
import SwiftUI

struct AssetGridItemView: View {
    var asset: Asset = EmptySecurity()
    
    var security: Security {
        asset.asSecurity ?? EmptySecurity()
    }
    
    var radioSelections: [String] = []
    var input: String = ""
    var assetGridType: AssetGridType = .standard
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                GradientView(colors: [Brand.Colors.greyV2.opacity(0.66),
                                      Brand.Colors.grey.opacity(0.24)],
                             cornerRadius: 6.0,
                             direction: .topLeading)
                    .frame(
                        width: 36,
                        height: 36,
                        alignment: .center)
                    .overlay (
                        VStack {
                            if let image = asset.symbolImage {
                                image
                                .frame(width: 20,
                                       height: 20,
                                       alignment: .center)
                                .foregroundColor(Brand.Colors.black)
                            } else {
                                GraniteText(.init(asset.symbol),
                                            Brand.Colors.black,
                                            .title3, .bold)
                            }
                        }
                    
                    )
                    .background(asset.symbolColor.cornerRadius(6.0)
                                    .shadow(color: Color.black, radius: 6.0, x: 3.0, y: 2.0))
                
                VStack(alignment: .leading) {
                    GraniteText(.init(asset.title),
                                .headline,
                                .regular,
                                .leading)
                    
                    GraniteText(.init(asset.subtitle),
                                asset.symbolColor,
                                .footnote,
                                .regular,
                                .leading,
                                style: .init(radius: 2, offset: .init(x: 1, y: 1)))
                }.padding(.leading, Brand.Padding.medium8)
                
                if asset.showDescription1 {
                    VStack(alignment: .trailing) {
                        
                        switch asset.assetType {
                        case .model:
                            GraniteText(.init(asset.description1),
                                        asset.symbolColor,
                                        .subheadline,
                                        .regular,
                                        .trailing,
                                        addSpacers: false)
                        default:
                            GraniteText(.init(asset.description1),
                                        asset.symbolColor,
                                        .subheadline,
                                        .regular)
                            
                            if !asset.isIncomplete {
                                GraniteText(.init(asset.description1_sub),
                                            security.statusColor,
                                            .footnote,
                                            .regular)
                            }
                        }
                    }.padding(.trailing, Brand.Padding.medium)
                }
                
                if !asset.isIncomplete {
                    VStack(alignment: .center, spacing: 2) {
                        Spacer()
                        
                        switch assetGridType {
                        case .standard:
                            VStack(alignment: .center, spacing: 4) {
                                if asset.showDescription2 {
                                    GraniteText(.init(asset.description2),
                                                asset.symbolColor,
                                                .footnote,
                                                .regular)
                                        .frame(width: 60, height: 12, alignment: .bottom)
                                }
                                
                                (security.statusColor)
                                    .clipShape(Circle())
                                    .frame(width: 6, height: 6, alignment: .top)
                            }
                        case .add:
                            if asset.canStore {
                                Circle()
                                    .foregroundColor(asset.symbolColor).overlay(
                                    
                                        GraniteText("+",
                                                    Brand.Colors.black,
                                                    .headline,
                                                    .bold)
                                                    .shadow(color: .black, radius: 6, x: 1, y: 1)
                                    
                                    
                                    )
                                    .frame(width: 24, height: 24)
                                    .padding(.leading, Brand.Padding.small)
                                    .shadow(color: .black, radius: 3, x: 1, y: 1)
                            }
                        case .radio:
                            Circle()
                                .foregroundColor(asset.symbolColor).overlay(
                                
                                    Circle()
                                        .foregroundColor(Brand.Colors.black)
                                        .padding(.top, Brand.Padding.xSmall)
                                        .padding(.leading, Brand.Padding.xSmall)
                                        .padding(.trailing, Brand.Padding.xSmall)
                                        .padding(.bottom, Brand.Padding.xSmall)
                                        .shadow(color: .black, radius: 2, x: 1, y: 1).overlay(
                                        
                                        
                                            Circle()
                                                .foregroundColor(radioSelections.contains(asset.assetID) ? asset.symbolColor : Brand.Colors.black)
                                                .padding(.top, Brand.Padding.xSmall)
                                                .padding(.leading, Brand.Padding.xSmall)
                                                .padding(.trailing, Brand.Padding.xSmall)
                                                .padding(.bottom, Brand.Padding.xSmall)
                                                .shadow(color: .black, radius: 2, x: 1, y: 1)
                                        )
                                )
                                .frame(width: 24, height: 24)
                                .padding(.leading, Brand.Padding.small)
                            
                        default:
                            EmptyView.init()
                        }
                        
                        Spacer()
                    }
                    .padding(.trailing, Brand.Padding.medium)
                } else if assetGridType == .add && asset.canStore {
                    VStack {
                        Spacer()
                        Circle()
                            .foregroundColor(asset.symbolColor).overlay(
                            
                                GraniteText("+",
                                            Brand.Colors.black,
                                            .headline,
                                            .bold)
                                            .shadow(color: .black, radius: 6, x: 1, y: 1)
                            
                            
                            )
                            .frame(width: 24, height: 24)
                            .padding(.leading, Brand.Padding.small)
                            .shadow(color: .black, radius: 3, x: 1, y: 1)
                        Spacer()
                    }
                    .padding(.trailing, Brand.Padding.medium)
                }
                
            }.opacity(asset.inValid ? 0.75 : 1.0)
            
            Rectangle().frame(height: 2.0,
                              alignment: .leading)
                .foregroundColor(.black)
                .padding(.top, Brand.Padding.small)
        }
    }
    
    func concat(_ value: String) -> String {
        String(value.prefix(24)).replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression) + "\(value.count > 24 ? "..." : "")"
    }
}
