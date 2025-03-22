import Granite
import Combine

struct Playground: GraniteComponent {
    @Command var center: Center
    @Relay var service: StockService
}
