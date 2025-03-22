import Granite
import SwiftUI

struct AssetGridView: View {
    @Environment(\.graniteRouter) var router
    
    public struct Payload: GranitePayload {
        public var stock: Stock
    }
    
    @GraniteAction<AssetGridView.Payload> var assetSelected
    
    var shouldRoute: Bool = true
    
    var type: AssetGridType
    var context: ModuleType
    
    var assetData: [Asset]
    var leadingPadding: CGFloat
    
    var radioSelections: [String] = []
    
    var label: String {
        switch assetData.first?.assetType {
        case .model:
            return "model"
        case .security:
            
            let stockType = assetData.first(where: { $0.asSecurity?.securityType == .stock })
            let cryptoType = assetData.first(where: { $0.asSecurity?.securityType == .crypto })
            
            let bothExists = stockType != nil && cryptoType != nil
            
            if bothExists {
                return "security"
            } else {
                let typeLabel = stockType?.asSecurity?.securityType ?? cryptoType?.asSecurity?.securityType
                return "\(typeLabel?.rawValue ?? "security")"
            }
            
        case .user:
            return "user"
        default:
            return "asset"
        }
    }
    
    var isComplete: Bool {
        assetData.filter{ $0.isIncomplete }.isEmpty
    }
    
    var showDescription1: Bool {
        assetData.first?.showDescription1 == true
    }
    
    var showDescription2: Bool {
        assetData.first?.showDescription2 == true
    }
    
    var assetType: AssetType {
        assetData.first?.assetType ?? .security
    }
    
    let columns = [
        GridItem(.flexible()),
    ]
    
    var body: some View {
        VStack {
            itemContainer
                .frame(
                    //                     minWidth: 300 + Brand.Padding.large,
                    //                       idealWidth: 414 + Brand.Padding.large,
                    maxWidth: .infinity,//420 + Brand.Padding.large,
                    //                       minHeight: 48 * 5,
                    //                       idealHeight: 50 * 5,
                    maxHeight: .infinity,//75 * 5,
                    alignment: .leading)
        }
    }
    
    var itemContainer: some View {
        VStack {
            VStack(alignment: .leading, spacing: 0.0) {
                Spacer()
                HStack(spacing: Brand.Padding.medium) {
                    GraniteText(.init(label),
                                .subheadline,
                                .regular,
                                .leading)
                    
                    if isComplete {
                        if showDescription1 {
                            switch assetType {
                            case .model:
                                GraniteText("expires",
                                            .subheadline,
                                            .regular,
                                            .trailing)
                            default:
                                GraniteText("price",
                                            .subheadline,
                                            .regular,
                                            .trailing)
                            }
                        }
                        
                        if showDescription2 {
                            switch type {
                            case .standard:
                                GraniteText("change",
                                            .subheadline,
                                            .regular).frame(width: 60)
                            case .add:
                                GraniteText("add",
                                            .subheadline,
                                            .regular)
                            case .radio:
                                GraniteText("select",
                                            .subheadline,
                                            .regular)
                            default:
                                EmptyView.init()
                            }
                        }
                    }
                }
                .padding(.bottom, Brand.Padding.xSmall)
                .padding(.leading, leadingPadding.isZero ? Brand.Padding.small : leadingPadding)
                .padding(.trailing, Brand.Padding.medium)
                
                Rectangle()
                    .frame(height: 2.0, alignment: .leading).foregroundColor(.black)
            }.frame(minHeight: 42, idealHeight: 42, maxHeight: 42)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(assetData, id: \.assetID) { asset in
                        AssetGridItemView(asset: asset,
                                          radioSelections: radioSelections,
                                          assetGridType: type)
                            .padding(.top, Brand.Padding.small)
//                            .modifier(TapAndLongPressModifier(
//                                        tapAction: {
//                                                if type == .radio {
//                                                    var selections = radioSelections
//                                                    if selections.contains(asset.assetID) {
//                                                        selections.removeAll(where: { $0 == asset.assetID })
//                                                    } else {
//                                                        selections.append(asset.assetID)
//                                                    }
//                                                    Haptic.basic()
//
//                                                    //TODO: set selections
//                                                } else {
//                                                    assetSelected.perform(AssetDetail.OnPush.Meta(asset: asset))
//                                                }
//                                        }))
                            .routeIf(shouldRoute, title: asset.asSecurity?.display ?? "", window: GraniteRouteWindowProperties(title: asset.asSecurity?.display ?? "", isChildWindow: true)) {
                                AssetDetail(stock: asset.asSecurity as? Stock)
                            } with: { router }
                            .onTapIf(shouldRoute == false) {
                                guard let stock = asset.asSecurity as? Stock else {
                                    return
                                }
                                assetSelected.perform(.init(stock: stock))
                            }
                            .padding(.leading, leadingPadding.isZero ? Brand.Padding.small : leadingPadding)
                    }//.padding(.leading, leadingPadding.isZero ? 0 : Brand.Padding.medium)
                }
            }.frame(maxWidth: .infinity,
                    minHeight: assetData.count > 0 ? 66 : 0.0,
                    alignment: .center)
            
            if type == .radio {
                Spacer()
                //TODO: confirm radio selection
//                GraniteButtonComponent(state: .init("confirm",
//                                                    action: {
//                                                        if self.radioSelections.isNotEmpty {
//                                                            return sendEvent(AssetGridEvents
//                                                                                .AssetsSelected(
//                                                                                    radioSelections),
//                                                                                .contact,
//                                                                                haptic: .light)
//                                                        }
//                                                    }))
//                    .opacity(radioSelections.isEmpty ? 0.5 : 1.0)
            }
        }
    }
}
