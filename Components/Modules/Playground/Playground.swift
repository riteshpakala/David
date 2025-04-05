import Granite
import Combine
import DavidKit

struct Playground: GraniteComponent {
    @Command var center: Center
    @Relay var service: StockService
}
