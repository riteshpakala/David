////
////  StockEvents.swift
////  * stoic
////
////  Created by Ritesh Pakala Rao on 12/18/20.
////  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
////
//
//import GraniteUI
//import SwiftUI
//import Combine
//
//public struct StockEvents {
//    public struct Search: GraniteEvent {
//        let query: String
//        public init(_ query: String) {
//            self.query = query
//        }
//
//        public var beam: GraniteBeamType {
//            .rebound
//        }
//
//        public var debounce: Double {
//            1.2.randomBetween(1.6)
//        }
//    }
//
//    public struct SearchDataResult: GraniteEvent {
//        let data: [StockServiceModels.Search]
//    }
//
//    public struct SearchQuoteResults: GraniteEvent {
//        let quotes: [StockServiceModels.Quotes]
//    }
//
//    public struct SearchResult: GraniteEvent {
//        let result: [Security]
//
//        public var beam: GraniteBeamType {
//            .rebound
//        }
//    }
//
//    //MARK: -- Movers
//    public struct GetMovers: GraniteEvent {
//        public var refresh: Bool
//        public var syncWithStoics: Bool
//        public var useStoics: Bool
//
//        public init(syncWithStoics: Bool = false, refresh: Bool = false, useStoics: Bool = false) {
//            self.syncWithStoics = syncWithStoics
//            self.refresh = refresh
//            self.useStoics = useStoics
//        }
//
//        public var beam: GraniteBeamType {
//            .rebound
//        }
//
//        public var async: DispatchQueue? {
//            GraniteThread.event
//        }
//    }
//
//    public struct MoversData: GraniteEvent {
//        let data: NetworkResponseData?
//        public var syncWithStoics: Bool
//        public init(_ syncWithStoics: Bool = false,
//                    data: NetworkResponseData?) {
//            self.syncWithStoics = syncWithStoics
//            self.data = data
//        }
//
//        public var async: DispatchQueue? {
//            GraniteThread.event
//        }
//    }
//
//    public struct MoverStockQuotes: GraniteEvent {
//        let movers: StockServiceModels.Movers
//        let quotes: [StockServiceModels.Quotes]
//
//        public var syncWithStoics: Bool
//        public init(_ syncWithStoics: Bool = false,
//                    movers: StockServiceModels.Movers,
//                    quotes: [StockServiceModels.Quotes]) {
//            self.syncWithStoics = syncWithStoics
//            self.movers = movers
//            self.quotes = quotes
//        }
//
//        public var async: DispatchQueue? {
//            GraniteThread.event
//        }
//    }
//
//    public struct MoverUpdated: GraniteEvent {
//        let success: Bool
//    }
//
//    public struct GlobalCategoryResult: GraniteEvent {
//        let losers: [Security]
//        let gainers: [Security]
//        let topVolume: [Security]
//
//        public init(_ topVolume: [Security],
//                    _ gainers: [Security],
//                    _ losers: [Security]) {
//            self.topVolume = topVolume
//            self.gainers = gainers
//            self.losers = losers
//        }
//
//        public var beam: GraniteBeamType {
//            .rebound
//        }
//
//        public var behavior: GraniteEventBehavior {
//            .quiet
//        }
//
//        public var async: DispatchQueue? {
//            GraniteThread.event
//        }
//    }
//
//    //MARK: -- Stock History
//    public struct GetStockHistory: GraniteEvent {
//        let security: Security
//        let interval: SecurityInterval
//        let daysAgo: Int
//
//        public init(security: Security,
//                    daysAgo: Int? = nil,
//                    interval: SecurityInterval = .day)//730 = 2 years - 1825 = 5 years
//        {
//            self.security = security
//            self.interval = interval
//            self.daysAgo = daysAgo ?? 2400
//        }
//
//        public var beam: GraniteBeamType {
//            .rebound
//        }
//
//        public var async: DispatchQueue? {
//            GraniteThread.event
//        }
//    }
//    
//    //MARK: -- Stock Interval
//    public struct GetStockInterval: GraniteEvent {
//        let symbol: String
//        let fromDate: Int64
//        let toDate: Int64
//        let interval: SecurityInterval
//
//        public init(symbol: String, fromDate: Int64, toDate: Int64, interval: SecurityInterval)
//        {
//            self.symbol = symbol
//            self.fromDate = fromDate
//            self.toDate = toDate
//            self.interval = interval
//        }
//    }
//
//    public struct History: GraniteEvent {
//        let data: [Stock]
//        let interval: SecurityInterval
//
//        public var beam: GraniteBeamType {
//            .rebound
//        }
//
//        public var async: DispatchQueue? {
//            GraniteThread.event
//        }
//    }
//
//    public struct Interval: GraniteEvent {
//        let data: [StockServiceModels.Stock]
//        let interval: SecurityInterval
//    }
//
//    //MARK: -- Misc
//    public struct GetTradingDay: GraniteEvent {
//        public var beam: GraniteBeamType {
//            .rebound
//        }
//    }
//    public struct TradingDayResult: GraniteEvent {
//        let data: [StockServiceModels.TradingDay]
//    }
//    public struct TradingDay: GraniteEvent {
//        let data: StockServiceModels.TradingDay
//
//        public var beam: GraniteBeamType {
//            .rebound
//        }
//    }
//}
//
