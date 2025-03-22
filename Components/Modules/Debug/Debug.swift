import Granite

struct Debug: GraniteComponent {
    @Command var center: Center
    @Relay var service: StockService
    @Relay var holdings: HoldingsService
}
