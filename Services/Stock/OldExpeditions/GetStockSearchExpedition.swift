////
////  GetStockSearchExpedition.swift
////  * stoic
////
////  Created by Ritesh Pakala Rao on 1/2/21.
////  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
////
//import GraniteUI
//import SwiftUI
//import Combine
//
//struct GetStockSearchExpedition: GraniteExpedition {
//    typealias ExpeditionEvent = StockEvents.Search
//    typealias ExpeditionState = StockState
//    
//    func reduce(
//        event: ExpeditionEvent,
//        state: ExpeditionState,
//        connection: GraniteConnection,
//        publisher: inout AnyPublisher<GraniteEvent, Never>) {
//        
//        publisher = state
//            .service
//            .search(matching: event.query)
//            .replaceError(with: [])
//            .map { StockEvents.SearchDataResult(data: $0) }
//            .eraseToAnyPublisher()
//    }
//}
//
//struct SearchResultExpedition: GraniteExpedition {
//    typealias ExpeditionEvent = StockEvents.SearchDataResult
//    typealias ExpeditionState = StockState
//    
//    func reduce(
//        event: ExpeditionEvent,
//        state: ExpeditionState,
//        connection: GraniteConnection,
//        publisher: inout AnyPublisher<GraniteEvent, Never>) {
//        
//        guard let data = event.data.first else { return }
//    
//        var sanitizedStocks: [StockServiceModels.Search.Stock] = []
//        
//        let validExchanges: [String] = [StockServiceClient.Exchanges.nasdaq.rawValue.uppercased(), StockServiceClient.Exchanges.nyse.rawValue.uppercased()]
//        
//        for item in data.data {
//            let keys = item.keys
//            
//            
//            if  keys.contains(StockServiceModels.Search.Keys.countryCode.rawValue),
//                keys.contains(StockServiceModels.Search.Keys.issueType.rawValue),
//                keys.contains(StockServiceModels.Search.Keys.symbolName.rawValue),
//                keys.contains(StockServiceModels.Search.Keys.companyName.rawValue),
//                keys.contains(StockServiceModels.Search.Keys.exchangeName.rawValue)
//                {
//                    
//                    if item[StockServiceModels.Search.Keys.countryCode.rawValue] == "US",
//                        item[StockServiceModels.Search.Keys.issueType.rawValue] == "STOCK",
//                        validExchanges.contains(item[StockServiceModels.Search.Keys.exchangeName.rawValue] ?? "") {
//                        
//                        
//                        let searchStock: StockServiceModels.Search.Stock = .init(
//                            exchangeName: item[StockServiceModels.Search.Keys.exchangeName.rawValue] ?? "",
//                            symbolName: item[StockServiceModels.Search.Keys.symbolName.rawValue] ?? "",
//                            companyName: item[StockServiceModels.Search.Keys.companyName.rawValue] ?? "")
//                        
//                        sanitizedStocks.append(searchStock)
//                    }
//                
//            }
//        }
//        
//        
//        let searchQuotes = sanitizedStocks.map { $0.asStock() }
//        
//        connection.request(StockEvents.SearchResult.init(result: searchQuotes))
//        
////        let symbols: [String] = sanitizedStocks.map { $0.symbolName }
////        publisher = state
////            .service
////            .getQuotes(symbols: symbols.uniques.joined(separator: ","))
////            .replaceError(with: [])
////            .map { StockEvents.SearchQuoteResults(quotes: $0) }
////            .eraseToAnyPublisher()
//    }
//}
//
//struct SearchQuoteResultExpedition: GraniteExpedition {
//    typealias ExpeditionEvent = StockEvents.SearchQuoteResults
//    typealias ExpeditionState = StockState
//
//    func reduce(
//        event: ExpeditionEvent,
//        state: ExpeditionState,
//        connection: GraniteConnection,
//        publisher: inout AnyPublisher<GraniteEvent, Never>) {
//
//        guard let data = event.quotes.first?.quoteResponse else { return }
//    
//        let searchQuotes = data.result.map { $0.asStock() }
//        
//        connection.request(StockEvents.SearchResult.init(result: searchQuotes))
//    }
//}
