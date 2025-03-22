import Granite
import GraniteUI
import SwiftUI

struct AssetSearch: GraniteComponent {
    @Command var center: Center
    
    @State var searchTimer: Timer? = nil
    
    @GraniteAction<AssetGridView.Payload> var assetSelected
    
    let shouldRoute: Bool
    init(shouldRoute: Bool = true) {
        self.shouldRoute = shouldRoute
    }
}
