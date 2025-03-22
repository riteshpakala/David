////
////  GetStockHistoryExpedition.swift
////  * stoic
////
////  Created by Ritesh Pakala Rao on 12/22/20.
////  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
////
//import GraniteUI
//import SwiftUI
//import Combine
//import CoreData
//
//struct GetStockHistoryExpedition: GraniteExpedition {
//    typealias ExpeditionEvent = StockEvents.GetStockHistory
//    typealias ExpeditionState = StockState
//    
//    func reduce(
//        event: ExpeditionEvent,
//        state: ExpeditionState,
//        connection: GraniteConnection,
//        publisher: inout AnyPublisher<GraniteEvent, Never>) {
//        
//        let todaysDate: Date = Date.today//.advanceDate(value: -30)//Calendar.nyCalendar.date(byAdding: .hour, value: -1, to: Date.today) ?? Date.today
//            
//        let pastDate: Date = Date.today.advanceDate(value: -1*abs(event.daysAgo))
//        
//        publisher = state
//            .service
//            .getStockChart(matching: event.security.ticker,
//                           from: "\(Int(pastDate.timeIntervalSince1970))",//"1591833600",
//                             to: "\(Int(todaysDate.timeIntervalSince1970))",
//                             interval: event.interval)
//            .replaceError(with: [])
//            .map { chart in
//                
//                if let result = chart.first?.chart.result.first,
//                   let quote = result.indicators.quote.first {
//                    
//                    let smallestArray = min(quote.close.count, min(quote.high.count, min(quote.low.count, min(quote.open.count, quote.volume.count))))
//                    
//                    var stocks: [Stock] = []
//                    for index in 0..<smallestArray {
//                        let close = quote.close[index] ?? 0.0
//                        
//                        let lastClose = index - 1 > 0 ? quote.close[index - 1] ?? close : close
//                        
//                        let changePercent = (close - lastClose) / close
//                        let changeAbsolue = close - lastClose
//                        
//                        let stock: Stock = .init(
//                            ticker: result.meta.symbol,
//                            date: Double(result.timestamp[index]).date(),
//                            open: quote.open[index] ?? 0.0,
//                            high: quote.high[index] ?? 0.0,
//                            low: quote.low[index] ?? 0.0,
//                            close: close,
//                            volume: quote.volume[index] ?? 0.0,
//                            changePercent: changePercent,
//                            changeAbsolute: changeAbsolue,
//                            interval: event.interval,
//                            exchangeName: result.meta.exchangeName,
//                            name: event.security.name,
//                            hasStrategy: event.security.hasStrategy,
//                            hasPortfolio: event.security.hasPortfolio)
//                        
//                        stocks.append(stock)
//                    }
//                    
//                    return StockEvents.History(data: stocks, interval: event.interval)
//                }
//                
//                return StockEvents.History(data: [], interval: event.interval)
//            }
//            .eraseToAnyPublisher()
//    }
//}
