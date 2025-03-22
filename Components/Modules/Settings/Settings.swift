import Granite
import SwiftUI

struct Settings: GraniteComponent {
    @Command var center: Center
    @Environment(\.openURL) var openURL
    
    @State var action = WebViewAction.idle
    @State var webState = WebViewState.empty
}
