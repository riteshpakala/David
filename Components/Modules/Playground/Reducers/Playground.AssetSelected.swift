import Granite

extension Playground {
    struct AssetSelected: GraniteReducer {
        typealias Center = Playground.Center
        
        @Relay var service: StockService
        @Event var complete: AssetHistoryFetched.Reducer
        
        @Payload var meta: AssetGridView.Payload?
        
        func reduce(state: inout Center.State) {
            guard let stock = meta?.stock else { return }
            //service.preload()
            
            state.stock = stock
            
            service.center.getHistoryResponse.notify(complete)
            
            service.center.getHistory.send(StockService.GetHistory.Meta(security: stock))
            state.currentStep = .tune
        }
    }
    
    //TODO: MAJOR, GET RANGES COMPLETE WILL BE FINAL STATE "issue#1 in Granite"
    struct AssetHistoryFetched: GraniteReducer {
        typealias Center = Playground.Center
        
        @Payload var meta: StockService.GetHistoryResponse.Meta?
        
        @Relay var service: StockService
        
        @Event var getRanges: GetRanges.Reducer
        
        func reduce(state: inout Center.State) {
//            guard let stock = state.stock else { return }
            guard let stock = meta?.security as? Stock else {
                return
            }
            service.preload()
            
            print("[Playground] Asset History Fetched \(service.isLoaded) \(service.state.stocks[stock.ticker]?[stock.interval.rawValue]?.count)")
            
            state.stocks = service.state.stocks[stock.ticker]?[stock.interval.rawValue] ?? []
            
            getRanges.send(Playground.GetRanges.Meta(stocks: service.state.stocks[stock.ticker]?[stock.interval.rawValue] ?? []))
        }
    }
}
