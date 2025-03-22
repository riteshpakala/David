import Granite

struct Floor: GraniteComponent {
    @Command var center: Center
    @Relay var service: HoldingsService
    
    
    
    var components: [AssetDetail] = []
    
    init() {
        components = (service.state.strategy?.investments ?? []).map { AssetDetail(.preview, stock: $0.stock) }
    }
}
