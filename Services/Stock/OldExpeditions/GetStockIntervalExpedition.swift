////
////  GetStockIntervalExpedition.swift
////  * stoic
////
////  Created by Ritesh Pakala Rao on 12/23/20.
////
//
//import Foundation
//import GraniteUI
//import SwiftUI
//import Combine
//
//struct GetStockIntervalExpedition: GraniteExpedition {
//    typealias ExpeditionEvent = StockEvents.GetStockInterval
//    typealias ExpeditionState = StockState
//    
//    func reduce(
//        event: ExpeditionEvent,
//        state: ExpeditionState,
//        connection: GraniteConnection,
//        publisher: inout AnyPublisher<GraniteEvent, Never>) {
//        
////        let todaysDate: Date =  Date.today.advanceDate(value: -30)//Calendar.nyCalendar.date(byAdding: .hour, value: -1, to: Date.today) ?? Date.today
////
////        let testDate: Date = Date.today.advanceDate(value: -60)// -1*abs(event.daysAgo))
//        
//        publisher = state
//            .service
//            .getStockChart(matching: event.symbol,
//                           from: "\(event.fromDate)",//"1591833600",
//                           to: "\(event.toDate)",
//                           interval: event.interval)
//            .replaceError(with: [])
//            .map {
//                
//                for item in $0 {
//                    guard let volume = item.chart.result.first?.indicators.quote.first?.volume else { break }
//                }
//                
//                return StockEvents.Interval(data: $0, interval: event.interval) }
//            .eraseToAnyPublisher()
//    }
//}
