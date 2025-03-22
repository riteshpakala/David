//
//  StockService.GetQuotes.swift
//  Stoic
//
//  Created by Ritesh Pakala Rao on 12/21/22.
//

import Granite
import SwiftUI
import Combine

extension StockService {
    struct GetQuotesResponse: GraniteReducer {
        typealias Center = StockService.Center
//        typealias Payload = Meta
        
        public struct Meta: GranitePayload {
            public let movers: StockServiceModels.Movers
            public let quotes: StockServiceModels.Quotes
        }
        
        @Payload var meta: Meta?
        
        func reduce(state: inout Center.State) {
            guard let event = meta else { return }

            let data = event.quotes.quoteResponse

            let topVolumeResponse = event.movers.finance.result.first(where: { $0.canonicalName == StockServiceModels.Quotes.Keys.topVolume }).map( { item in item.quotes.map { $0.symbol } }) ?? []

            let losersResponse = event.movers.finance.result.first(where: { $0.canonicalName == StockServiceModels.Quotes.Keys.losers }).map( { item in item.quotes.map { $0.symbol } }) ?? []

            let gainersResponse = event.movers.finance.result.first(where: { $0.canonicalName == StockServiceModels.Quotes.Keys.gainers }).map( { item in item.quotes.map { $0.symbol } }) ?? []

            let topVolumeQuotes = data.result.filter { topVolumeResponse.contains($0.symbol) }.map { $0.asStock() }.sorted(by: { $0.volume > $1.volume })
            let losersQuotes = data.result.filter { losersResponse.contains($0.symbol) }.map { $0.asStock() }.sorted(by: { $0.changePercent < $1.changePercent })
            let gainersQuotes = data.result.filter { gainersResponse.contains($0.symbol) }.map { $0.asStock() }.sorted(by: { $0.changePercent > $1.changePercent })

            let categories = Movers.Categories(topVolumeQuotes, gainersQuotes, losersQuotes)

            state.movers = .init(stocks: categories)
            print("{TEST} am i here \(categories.losers.count)")
        }
    }
}
