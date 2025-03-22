import Granite

struct AssetSection: GraniteComponent {
    @Command var center: Center
    @Relay var service: StockService
    
    public init(context: ModuleType, _ securityType: SecurityType) {
        center.state.context = context
        center.state.securityType = securityType
    }
}
