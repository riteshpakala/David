import Foundation
import SwiftUI

extension View {
    
    public func addGraniteSheet<Background : View>(id: String = GraniteSheetManager.defaultId,
                                                   _ manager : GraniteSheetManager, background : Background) -> some View {
        GraniteSheetContainerView(id: id, content: self, background: background)
            .environmentObject(manager)
    }
    
    public func addGraniteSheet(id: String = GraniteSheetManager.defaultId,
                                _ manager : GraniteSheetManager) -> some View {
        GraniteSheetContainerView(id: id, content: self, background: Color.black)
            .environmentObject(manager)
    }
}
