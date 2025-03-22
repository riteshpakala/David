import Granite

struct HoldingsService: GraniteService {
    @Service var center: Center
    @Relay var stockService: StockService
    
    init() {
        center.$state.binding.isSyncing.wrappedValue = false
    }
}
