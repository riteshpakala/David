import Granite
import DavidKit

struct Portfolio: GraniteComponent {
    @Command var center: Center
    
    @Relay var stockService: StockService
    @Relay var service: HoldingsService
    
    var canSync: Bool {
        service.state.hasInvestments
    }
}
