import Foundation
import SwiftUI

struct GraniteSheetContainerView<Content : View, Background : View> : View {
    
    @EnvironmentObject var manager : GraniteSheetManager
    
    let id: String
    let content : Content
    let background : Background
    
    init(id: String = GraniteSheetManager.defaultId,
         content : @autoclosure () -> Content,
         background : @autoclosure () -> Background) {
        self.id = id
        self.content = content()
        self.background = background()
    }
    
    var body: some View {
        #if os(iOS)
        if #available(iOS 14.5, *) {
           content
               .fullScreenCover(isPresented: manager.hasContent(with: .cover)) {
                   sheetContent(for: manager.style)
               }
               .sheet(isPresented: manager.hasContent(with: .sheet)) {
                   sheetContent(for: manager.style)
               }
       } else if #available(iOS 14.0, *) {
            content
                .fullScreenCover(isPresented: manager.hasContent(with: .cover)) {
                    sheetContent(for: manager.style)
                }
                .overlay (
                    EmptyView()
                        .sheet(isPresented: manager.hasContent(with: .sheet)) {
                            sheetContent(for: manager.style)
                        }
                )
        } else {
            content
                .sheet(isPresented: manager.hasContent(with: .sheet)) {
                    sheetContent(for: manager.style)
                }
                .composeFullScreenCover(isPresented: manager.hasContent(with: .cover)) {
                    sheetContent(for: manager.style)
                }
        }
        #else
        content
            .sheet(isPresented: manager.hasContent(id: self.id, with: .sheet)) {
                sheetContent(for: manager.style)
            }
        #endif
    }
    
    fileprivate func sheetContent(for style : GraniteSheetPresentationStyle) -> some View {
        ZStack {
            #if os(iOS)
            background
                .edgesIgnoringSafeArea(.all)
                .zIndex(5)
            #endif
            
            if style == .sheet {
                
                #if os(iOS)
                manager.content
                    .graniteSheetDismissable(shouldPreventDismissal: manager.shouldPreventDismissal)
                    .zIndex(6)
                #else
                manager.models[self.id]?.content
                    .zIndex(6)
                #endif
            }
            else {
                manager.models[self.id]?.content
                    .zIndex(6)
            }
        }
    }
    
}
