import Granite
import SwiftUI

struct History: GraniteComponent {
    @Command var center: Center
    @Relay var service: HoldingsService
    
    @Environment(\.graniteRouter) var router
}
