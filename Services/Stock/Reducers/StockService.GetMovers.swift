//
//  StockService.GetMovers.swift
//  Stoic
//
//  Created by Ritesh Pakala Rao on 12/20/22.
//
import Granite
import SwiftUI
import Combine

extension StockService {
    struct GetMovers: GraniteReducer {
        typealias Center = StockService.Center
        typealias Metadata = Meta
        
        public struct Meta: GranitePayload {
            public var refresh: Bool
            public var syncWithStoics: Bool
            public var useStoics: Bool
    
            public init(syncWithStoics: Bool = false, refresh: Bool = false, useStoics: Bool = true) {
                self.syncWithStoics = syncWithStoics
                self.refresh = refresh
                self.useStoics = useStoics
            }
        }
        
        @Event var response: GetMoversResponse.Reducer
        
        @Relay var network: NetworkService
        
        func reduce(state: inout Center.State, payload: Metadata) {
            let event = payload
            var needsUpdate = true
            
            if !event.syncWithStoics {
                //let result = coreDataInstance.networkResponse(forRoute: state.service.movers)

                //get cached data and return instead

                let age = 12//(result?.date ?? Date()).minutesFrom(.today)

                GraniteLogger.info("stock movers last updated: \(age) minutes ago", .expedition, focus: true)

                //in minutes
                if age < 12 {
                    needsUpdate = false
                }
            }
            
            if needsUpdate {
                if event.useStoics && !event.syncWithStoics {
                    
                    network.request(Requests.Stock.GetMovers.Stoic())
                            .sink { result in

                                switch result {

                                case .failure(let error):
                                    print("{TEST} \(error.localizedDescription)")
                                    break

                                case .finished:
                                    break

                                }

                            } receiveValue: { result in
                                response.send(GetMoversResponse.Meta(dataNew: nil, dataStoic: result))
//                                getQuotes(dataNew: nil, dataStoic: result)
                            }
                            .store(in: network.center.$state)

//                    GraniteLogger.info("fetching new movers from stoic\nneeds update:\(needsUpdate) - self: \(String(describing: self))", .network, focus: true)
                } else {
                    network.request(Requests.Stock.GetMovers.New())
                            .sink { result in

                                switch result {

                                case .failure(let error):
                                    print("{TEST} \(error.localizedDescription)")
                                    break

                                case .finished:
                                    break

                                }

                            } receiveValue: { result in
                                print("{TEST} hello")
                                response.send(GetMoversResponse.Meta(dataNew: result, dataStoic: nil))
//                                getQuotes(dataNew: result, dataStoic: nil)
                            }
                            .store(in: network.center.$state)

                    GraniteLogger.info("[DEPRECATED] fetching new movers\nneeds update:\(needsUpdate) - self: \(String(describing: self))", .network, focus: true)
                }
            }
        }
        
        func getQuotes(dataNew: Requests.Stock.GetMovers.Movers?,
                       dataStoic: Requests.Stock.GetMovers.MoversStoic?) {
            
            if let movers = dataStoic?.Items.first?.data {
                let symbols: [String] = movers.finance.result.flatMap { item in item.quotes.map { $0.symbol } }

                network.request(Requests.Stock.GetQuotes(symbols: symbols.uniques.joined(separator: ",")))
                    .sink { result in

                        switch result {

                        case .failure(let error):
                            print("{TEST} \(error.localizedDescription)")
                            break

                        case .finished:
                            break

                        }

                    } receiveValue: { result in
                        response.send(GetQuotesResponse.Meta(movers: movers, quotes: result))
                    }
                    .store(in: network.center.$state)
            }
        }
    }
    
    struct GetMoversResponse: GraniteReducer {
        typealias Center = StockService.Center
        typealias Metadata = Meta
        
        public struct Meta: GranitePayload {
            public var dataNew: Requests.Stock.GetMovers.Movers?
            public var dataStoic: Requests.Stock.GetMovers.MoversStoic?
        }
        
        @Event var response: GetQuotesResponse.Reducer
        
        @Relay var network: NetworkService
        
        func reduce(state: inout Center.State, payload: Metadata) {
            print("{TEST} data exists: \(payload.dataStoic != nil) \(payload.dataStoic?.Items.count)")
            
            if let movers = payload.dataStoic?.Items.first?.data {
                let symbols: [String] = movers.finance.result.flatMap { item in item.quotes.map { $0.symbol } }

                print("{TEST} fetching quotes for \(symbols.uniques.joined(separator: ","))")
                
                network.request(Requests.Stock.GetQuotes(symbols: symbols.uniques.joined(separator: ",")))
                    .sink { result in

                        switch result {

                        case .failure(let error):
                            print("{TEST} \(error.localizedDescription)")
                            break

                        case .finished:
                            break

                        }

                    } receiveValue: { result in
                        response.send(GetQuotesResponse.Meta(movers: movers, quotes: result))
                    }
                    .store(in: network.center.$state)
            }
        }
    }
}
