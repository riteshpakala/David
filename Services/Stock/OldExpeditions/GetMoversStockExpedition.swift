////
////  GetMoversStockExpeditionExpedition.swift
////  * stoic
////
////  Created by Ritesh Pakala Rao on 12/22/20.
////  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
////
//import GraniteUI
//import SwiftUI
//import Combine
//
//struct GetMoversStockExpedition: GraniteExpedition {
//    typealias ExpeditionEvent = StockEvents.GetMovers
//    typealias ExpeditionState = StockState
//    
//    func reduce(
//        event: ExpeditionEvent,
//        state: ExpeditionState,
//        connection: GraniteConnection,
//        publisher: inout AnyPublisher<GraniteEvent, Never>) {
//        
//        var needsUpdate: Bool = true
//        
//        if !event.syncWithStoics {
//            let result = coreDataInstance.networkResponse(forRoute: state.service.movers)
//            
//            let age = (result?.date ?? Date()).minutesFrom(.today)
//            
//            GraniteLogger.info("stock movers last updated: \(age) minutes ago", .expedition, focus: true)
//            
//            //in minutes
//            if age < 12, let data = result?.data {
//                
//                if let unarchivedData = data.decodeNetwork(type: StockServiceModels.MoversArchiveable.self),
//                   let movers = unarchivedData.movers {
//                    
//                    connection.request(StockEvents.MoverStockQuotes(movers: movers, quotes: unarchivedData.quotes))
//                    
//                    GraniteLogger.info("got the cached movers", .expedition, focus: true)
//                }
//                
//                needsUpdate = false
//            }
//        }
//        
//        if needsUpdate {
//            if event.useStoics && !event.syncWithStoics {
//                publisher = state
//                    .service
//                    .getMoversFromStoic()
//                    .replaceError(with: nil)
//                    .map {
//                        if let movers = $0 as? StockServiceModels.MoversStoic,
//                           let data = movers.Items.first?.data {
//                            return StockEvents.MoversData(event.syncWithStoics, data: data)
//                        } else {
//                            GraniteLogger.info("failed", .network, focus: true)
//                            return StockEvents.MoversData(event.syncWithStoics, data: nil)
//                        }
//                    }.eraseToAnyPublisher()
//
//                GraniteLogger.info("fetching new movers from stoic\nneeds update:\(needsUpdate) - self: \(String(describing: self))", .network, focus: true)
//            } else {
////                publisher = state
////                    .service
////                    .getMovers()
////                    .replaceError(with: nil)
////                    .map {
////                        return StockEvents.MoversData(event.syncWithStoics, data: $0) }
////                    .eraseToAnyPublisher()
////
//                GraniteLogger.info("[DEPRECATED] fetching new movers\nneeds update:\(needsUpdate) - self: \(String(describing: self))", .network, focus: true)
//            }
//        }
//    }
//}
//
//struct MoversDataExpedition: GraniteExpedition {
//    typealias ExpeditionEvent = StockEvents.MoversData
//    typealias ExpeditionState = StockState
//    
//    func reduce(
//        event: ExpeditionEvent,
//        state: ExpeditionState,
//        connection: GraniteConnection,
//        publisher: inout AnyPublisher<GraniteEvent, Never>) {
//        
//        GraniteLogger.info("got the movers data for stocks - self: \(String(describing: self))", .network, focus: true)
//        
//        guard let data = event.data as? StockServiceModels.Movers else { GraniteLogger.info("failed to push movers to fetch quotes - self: \(String(describing: self))", .network, focus: true); return }
//        
//        let symbols: [String] = data.finance.result.flatMap { item in item.quotes.map { $0.symbol } }
//        
//        publisher = state
//            .service
//            .getQuotes(symbols: symbols.uniques.joined(separator: ","))
//            .replaceError(with: [])
//            .map {
//                
//                let archive: StockServiceModels.MoversArchiveable = .init(data, $0)
//                if let data = archive.archived {
//                    coreDataInstance.save(route: state.service.movers,
//                                          data: data,
//                                          responseType: .movers)
//                }
//                
//                
//                return StockEvents.MoverStockQuotes(event.syncWithStoics, movers: data, quotes: $0)
//            }
//            .eraseToAnyPublisher()
//        
//    }
//}
//
//struct MoversStockQuotesExpedition: GraniteExpedition {
//    typealias ExpeditionEvent = StockEvents.MoverStockQuotes
//    typealias ExpeditionState = StockState
//    
//    func reduce(
//        event: ExpeditionEvent,
//        state: ExpeditionState,
//        connection: GraniteConnection,
//        publisher: inout AnyPublisher<GraniteEvent, Never>) {
//        
//        GraniteLogger.info("pushing with quotes - self: \(String(describing: self))", .network, focus: true)
//        
//        if event.syncWithStoics {
//            do {
//                let dict = try event.movers.toDictionary()
//                publisher = state
//                    .service
//                    .sendMovers(data: dict)
//                    .replaceError(with: false)
//                    .map { StockEvents.MoverUpdated(success: $0) }
//                    .eraseToAnyPublisher()
//            } catch let error {
//                GraniteLogger.info("\(error)\n\(String(describing: self))", .expedition, focus: true)
//            }
//        }
//        
//        guard let data = event.quotes.first?.quoteResponse else { return }
//        
//        let topVolumeResponse = event.movers.finance.result.first(where: { $0.canonicalName == StockServiceModels.Quotes.Keys.topVolume }).map( { item in item.quotes.map { $0.symbol } }) ?? []
//        
//        let losersResponse = event.movers.finance.result.first(where: { $0.canonicalName == StockServiceModels.Quotes.Keys.losers }).map( { item in item.quotes.map { $0.symbol } }) ?? []
//        
//        let gainersResponse = event.movers.finance.result.first(where: { $0.canonicalName == StockServiceModels.Quotes.Keys.gainers }).map( { item in item.quotes.map { $0.symbol } }) ?? []
//        
//        let topVolumeQuotes = data.result.filter { topVolumeResponse.contains($0.symbol) }.map { $0.asStock() }.sorted(by: { $0.volume > $1.volume })
//        let losersQuotes = data.result.filter { losersResponse.contains($0.symbol) }.map { $0.asStock() }.sorted(by: { $0.changePercent < $1.changePercent })
//        let gainersQuotes = data.result.filter { gainersResponse.contains($0.symbol) }.map { $0.asStock() }.sorted(by: { $0.changePercent > $1.changePercent })
//        
//        let result = StockEvents.GlobalCategoryResult.init(topVolumeQuotes, gainersQuotes, losersQuotes)
//        
//        connection.request(result)
//    }
//}
