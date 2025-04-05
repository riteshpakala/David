import Granite
import DavidKit

extension HoldingsService.Center {
    struct Order: GraniteReducer {
        typealias Center = HoldingsService.Center
        
        struct Meta: GranitePayload {
            let stock: Stock
            let amount: Double
            let newValue: Double
        }
        
        @Payload var meta: Meta?
        
        func reduce(state: inout Center.State) {
            guard let meta = meta else { return }
            
            state.wallet.current = meta.newValue
            state.strategy?.valueChanges.append(.init(date: meta.stock.date, value: meta.newValue))
            
            guard let index = state
                .strategy?
                .investments
                .firstIndex(where: {
                    $0.stock.ticker == meta.stock.ticker && $0.isClosed == false
                }) else {
                
                state
                    .strategy?
                    .investments
                    .append(.init(stock: meta.stock,
                                  soldShares: [],
                                  boughtShares: [
                                    .init(stock: meta.stock,
                                          date: .today,
                                          shares: meta.amount)
                                  ]))
                return
            }
            
            state.strategy?.investments[index].boughtShares.append(.init(stock: meta.stock, date: .today, shares: meta.amount))
        }
    }
    
    struct Sell: GraniteReducer {
        typealias Center = HoldingsService.Center
        
        @Payload var meta: HoldingsService.Center.Order.Meta?
        
        func reduce(state: inout Center.State) {
            guard let meta = meta else { return }
            
            state.wallet.current = meta.newValue
            
            guard let index = state
                .strategy?
                .investments
                .firstIndex(where: {
                    $0.stock.ticker == meta.stock.ticker && $0.isClosed == false
                }) else {
                return
            }
            
            state.strategy?.investments[index].soldShares.append(.init(stock: meta.stock, date: .today, shares: meta.amount))
        }
    }
    
    struct Close: GraniteReducer {
        typealias Center = HoldingsService.Center
        
        struct Meta: GranitePayload {
            let stock: Stock
        }
        
        @Payload var meta: Meta?
        
        func reduce(state: inout Center.State) {
            guard let meta = meta else { return }
            
            guard let index = state
                                .strategy?
                                .investments
                                .firstIndex(where: {
                                    $0.stock.ticker == meta.stock.ticker && $0.isClosed == false
                                }) else {
                return
            }
            
            if let investment = state.strategy?.investments[index] {
                
                state.wallet.current += investment.ownedShares * meta.stock.lastValue
                
                state
                    .strategy?
                    .investments[index]
                    .soldShares
                    .append(.init(stock: meta.stock,
                                  date: .today,
                                  shares: investment.ownedShares))
                
                state.strategy?.investments[index].close()
            }
        }
    }
}
