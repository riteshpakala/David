import Granite
import GraniteUI
import SwiftUI

//class AssetSearchLock {
//    static var shared = AssetSearchLock()
//    var pause: Bool = false
//}

extension AssetSearch: View {
    public var view: some View {
        ZStack {
            if state.isEditing {
                Brand.Colors.black
                    .opacity(0.75)
                    .ignoresSafeArea()
                    .fitToContainer()
            }
            
            VStack {
                searchBar
                    .padding(.horizontal, Brand.Padding.medium)
                    .padding(.top, Brand.Padding.medium)
                    .onChange(of: center.$state.binding.wrappedValue.query) { value in
                        
                        searchTimer?.invalidate()
                        searchTimer = nil
                        
                        guard state.query.isNotEmpty else { return }
                        
                        center.$state.binding.wrappedValue.isEditing = true
                        center.$state.binding.wrappedValue.isSearching = true
                        
                        searchTimer = Timer.scheduledTimer(
                            withTimeInterval: 0.4.randomBetween(0.8),
                            repeats: false) { timer in
                                
                                timer.invalidate()
                                
                                DispatchQueue.main.async {
                                    let results = TickerSearchManager.shared.search(state.query)
                                    
                                    center.searchLocal.send(SearchLocal.Meta(data: results))
                                    center.$state.binding.wrappedValue.isSearching = false
//                                    print("[AssetSearch] \(results.map { $0.symbol })")
                                }
                                
//                                guard AssetSearchLock.shared.pause == false else {
//                                    AssetSearchLock.shared.pause = false
//                                    return
//                                }
//                                AssetSearchLock.shared.pause = true
//                                center.search.send()
                            }
                    }
                
                if state.stocks.isNotEmpty && state.isEditing {
                    AssetGridView(shouldRoute: self.shouldRoute,
                                  type: .standard,
                                  context: .portfolio,
                                  assetData: state.stocks,
                                  leadingPadding: Brand.Padding.medium)
                    .attach(assetSelected, at: \.assetSelected, transform: { payload in
                        GraniteHaptic.light.invoke()
                        resetView()
                        return payload
                    })
                    .background(Brand.Colors.black)
                    .ignoresSafeArea()
                    .fitToContainer()
                }
                
                Spacer()
            }
            
            if state.isSearching && state.query.isNotEmpty {
                VStack {
                    Group {
                        HStack {
                            Spacer()
                            GraniteText("searching for \"\(state.query)\"...", .subheadline, .regular)
                                .padding(.trailing, Brand.Padding.medium)
                            ProgressView().scaleEffect(0.66)
                            Spacer()
                        }
                        .frame(height: 24)
                        .padding(.top, 7 + 24 + 24)
                        .transition(.move(edge: .top))
                    }
                    Spacer()
                }
                .allowsHitTesting(false)
            }
        }
    }
}

extension AssetSearch {
    public var searchBar: some View {
        VStack {
            HStack {
                HStack {
                    Image("search_icon")
                        .resizable()
                        .frame(width: 20, height: 20, alignment: .leading)
                        .padding(.leading, Brand.Padding.medium)
                        .foregroundColor(Brand.Colors.grey)
                    
                    TextField("search markets",
                              text: center.$state.binding.query)
                        .background(Color.clear)
                        .textFieldStyle(PlainTextFieldStyle())
                        .font(Fonts.live(.headline, .regular))
                        .autocorrectionDisabled(true)
                        .onTapGesture {
                            center.$state.binding.wrappedValue.isEditing = true
                        }.frame(height: 36)
                }.background(Brand.Colors.greyV2.opacity(0.13))
                .cornerRadius(6.0)
     
                if state.isEditing {
                    Group {
                        Button(action: {
                            resetView()
                        }) {
                            GraniteText("cancel", .subheadline, .regular)
                        }
                        .buttonStyle(PlainButtonStyle())
//                        .transition(.move(edge: .trailing))
//                        .animation(.default)
                    }
                }
            }
        }
    }
    
    func resetView() {
        #if canImport(UIKit)
        self.hideKeyboard()
        #endif
        center.$state.binding.wrappedValue.isEditing = false
        center.$state.binding.wrappedValue.query = ""
        center.$state.binding.wrappedValue.stocks.removeAll()
        self.searchTimer?.invalidate()
    }
}

#if os(macOS)
extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}
#endif
