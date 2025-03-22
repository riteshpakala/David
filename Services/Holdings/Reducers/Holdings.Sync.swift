import Granite

extension HoldingsService.Center {
    struct Sync: GraniteReducer {
        typealias Center = HoldingsService.Center
        
        var notifiable: Bool {
            true
        }
        
        @Payload var meta: StockService.GetHistoryResponse.Meta?
        
        @Relay var service: StockService
        
        @Event var complete: SyncComplete.Reducer
        
        func reduce(state: inout Center.State) {
            guard let strategy = state.strategy else { return }
            
            state.isSyncing = true
            
            service.preload()
            
            let index: Int
            
            if let meta = self.meta {
                let nextIndex = strategy.investments.firstIndex(where: { ($0.stock.asSecurity ?? EmptySecurity()).assetID == meta.security.assetID }) ?? strategy.investments.count
                
                index = nextIndex + 1
            } else {
                index = 0
            }
            
            if index >= strategy.investments.count - 1 {
                service.center.getHistoryResponse.notify(complete)
            } else {
                service.center.getHistoryResponse.notify(self)
            }

            let stock = strategy.investments[index].stock
            
            service.center.getHistory.send(StockService.GetHistory.Meta(security: stock))

            print("{TEST} processing \(stock.ticker) ~ \(index + 1)/\(strategy.investments.count) ~ notif count: \(service.center.getHistoryResponse.notificationCount)")
        }
    }
    
    struct SyncComplete: GraniteReducer {
        typealias Center = HoldingsService.Center
        
        @Relay var service: StockService
        
        func reduce(state: inout Center.State) {
            state.isSyncing = false
            
            guard let strategy = state.strategy else { return }
            
            state.lastSyncDate = .today
            //Sync stock services, fetched stocks into holdings' services' investment store
            for (i, item) in strategy.investments.enumerated() {
                let interval = item.stock.interval.rawValue
                let ticker = item.stock.ticker

                guard let stocks = service.state.stocks[ticker]?[interval] else {
                    continue
                }

                let newStocks = stocks.filterAbove(item.stock.date)
                print("{TEST} newStocks \(newStocks.count)")
                state.strategy?.investments[i].update(newStocks)
            }
        }
    }
}
