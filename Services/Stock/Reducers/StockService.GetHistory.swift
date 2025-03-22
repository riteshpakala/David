//
//  StockService.GetHistory.swift
//  Stoic
//
//  Created by Ritesh Pakala Rao on 1/3/23.
//

import Granite
import SwiftUI
import Combine

extension StockService {
    struct GetHistoryDebug: GraniteReducer {
        typealias Center = StockService.Center
        
        @Event var response: GetHistoryDebugResponse.Reducer
        
        func reduce(state: inout Center.State) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                response.send(GetHistoryDebugResponse.Meta(index: 1))
            }
        }
    }
    
    struct GetHistoryDebugResponse: GraniteReducer {
        typealias Center = StockService.Center
        
        struct Meta: GranitePayload {
            var index: Int
        }
        
        @Payload var meta: Meta?
        
        func reduce(state: inout Center.State) {
            print("{TEST} 2 response")
        }
    }
    
    struct GetHistory: GraniteReducer {
        typealias Center = StockService.Center
        
        public struct Meta: GranitePayload {
            public var security: Security
            public var force: Bool = false
        }
        
        @Event var response: GetHistoryResponse.Reducer
        
        @Relay var network: NetworkService
        
        @Payload var meta: Meta?
        
        func reduce(state: inout Center.State) {
            guard let payload = meta else { return }
            //TODO: remove when proper checking mechanism is set
//            guard state.stocks[payload.security.ticker] == nil else {
//                print("{TEST} stocks already fetched")
//                return 
//            }
            
            if let stocks = state.stocks[payload.security.ticker.uppercased()]?["1d"] {
                
                guard let lastValidTradingDay = Date.lastValidTradingDay else {
                    print("[StockService] Syncing failed, could not get last valid trading day")
                    return
                }
                
                if let lastStockDate = stocks.sortAsc.last?.date,
                   (lastStockDate.compare(lastValidTradingDay) == .orderedSame || lastStockDate.compare(lastValidTradingDay) == .orderedDescending || abs(lastStockDate.hoursFrom(lastValidTradingDay)) <= 1) {
                    
                    response.send(GetHistoryResponse.Meta(security: payload.security, interval: .day, stock: nil, skip: true))
                    
                    return
                } else {
                    let hours = (stocks.sortAsc.last?.date ?? Date()).hoursFrom(lastValidTradingDay)
                    print("[StockService] \(stocks.sortAsc.last?.date.compare(lastValidTradingDay).rawValue), lastTradingDay: \(lastValidTradingDay.asStringWithTime). lastSecurityDay: \(stocks.sortAsc.last?.date.asStringWithTime ?? ""), hours: \(hours)")
                }
            } else {
                print("[StockService] No stock with this ticker \(payload.security.ticker.uppercased()) found. \(state.stocks.keys)")
            }
            
            print("[StockService] fetch history for \(payload.security.ticker)")
            
            network.request(Requests.Stock.GetHistory(ticker: payload.security.ticker))
                    .sink { result in

                        switch result {

                        case .failure(let error):
                            break

                        case .finished:
                            break

                        }

                    } receiveValue: { result in
                        print("[StockService] received \(result.chart.result.count) from getHistory")
                        response.send(GetHistoryResponse.Meta(security: payload.security, interval: .day, stock: result))
                    }
                    .store(in: network.center.$state)
        }
    }
    
    struct GetHistoryResponse: GraniteReducer {
        typealias Center = StockService.Center
        
        public struct Meta: GranitePayload {
            public var security: Security
            public var interval: SecurityInterval
            public var stock: Requests.Stock.GetHistory.Response?
            public var skip: Bool = false
        }
        
        @Payload var meta: Meta?
        
        func reduce(state: inout Center.State) {
            guard let payload = self.meta else { return }
            
            guard payload.skip == false else {
                print("[StockService] Skipped Syncing \(payload.security.ticker.uppercased())")
                return
            }
            
            if let result = payload.stock?.chart.result.first,
               let quote = result.indicators.quote.first {
                print("[StockService] getHistoryResponse is running")
                let smallestArray = min(quote.close.count, min(quote.high.count, min(quote.low.count, min(quote.open.count, quote.volume.count))))
                
                var stocks: [Stock] = []
                for index in 0..<smallestArray {
                    let close = quote.close[index] ?? 0.0
                    
                    let lastClose = index - 1 > 0 ? quote.close[index - 1] ?? close : close
                    
                    let changePercent = (close - lastClose) / close
                    let changeAbsolue = close - lastClose
                    
                    let stock: Stock = .init(
                        ticker: result.meta.symbol,
                        date: Double(result.timestamp[index]).date(),
                        open: quote.open[index] ?? 0.0,
                        high: quote.high[index] ?? 0.0,
                        low: quote.low[index] ?? 0.0,
                        close: close,
                        volume: quote.volume[index] ?? 0.0,
                        changePercent: changePercent,
                        changeAbsolute: changeAbsolue,
                        interval: payload.interval,
                        exchangeName: result.meta.exchangeName,
                        name: payload.security.name,
                        hasStrategy: false,
                        hasPortfolio: false)
                    
                    stocks.append(stock)
                }
                
                let stocksSorted = (stocks.sortAsc as? [Stock]) ?? stocks
                
                state.stocks[payload.security.ticker] = [payload.interval.rawValue : stocksSorted]
            }
        }
    }
}
