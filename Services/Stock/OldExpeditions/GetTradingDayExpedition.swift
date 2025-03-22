////
////  TradingDayReducer.swift
////  * stoic
////
////  Created by Ritesh Pakala Rao on 12/18/20.
////  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
////
//import GraniteUI
//import SwiftUI
//import Combine
//
//struct GetTradingDayExpedition: GraniteExpedition {
//    typealias ExpeditionEvent = StockEvents.GetTradingDay
//    typealias ExpeditionState = StockState
//    
//    func reduce(
//        event: ExpeditionEvent,
//        state: ExpeditionState,
//        connection: GraniteConnection,
//        publisher: inout AnyPublisher<GraniteEvent, Never>) {
//        
//        let today: Date = Date.today
//        var days: [Date] = []
//        
//        for i in 1..<13 {
//            days.append(today.advanceDate(value: i))
//        }
//        
//        var nextTradingDate: Date = today
//        
//        for day in days {
//            if !day.dayofTheWeek.isWeekend && !day.isUSHoliday {
//                nextTradingDate = day
//                break
//            }
//        }
//        
//        GraniteLogger.info("nextTradingDay: \(nextTradingDate.asString)", .expedition)
//        
//        let components = nextTradingDate.dateComponents()
//        //If friday & days left < 3, next month
//        //
//        publisher = state
//            .service
//            .getTradingDays(month: "\(components.month)", year: "\(components.year)")
//            .replaceError(with: [])
//            .map { StockEvents.TradingDayResult.init(data: $0) }
//            .eraseToAnyPublisher()
//    }
//}
//
//struct TradingDayResultExpedition: GraniteExpedition {
//    typealias ExpeditionEvent = StockEvents.TradingDayResult
//    typealias ExpeditionState = StockState
//    
//    func reduce(
//        event: ExpeditionEvent,
//        state: ExpeditionState,
//        connection: GraniteConnection,
//        publisher: inout AnyPublisher<GraniteEvent, Never>) {
//        
//        for item in event.data {
//            
//            GraniteLogger.info(item.date.asString+" - isOpen: \(item.isOpen)", .expedition)
//        }
//    }
//}
