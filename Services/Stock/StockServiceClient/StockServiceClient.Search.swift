//
//  StockService.Search.swift
//  * stoic
//
//  Created by Ritesh Pakala Rao on 1/2/21.
//

import Foundation
import Combine
import GraniteUI

extension StockServiceClient {
    public func search(matching ticker: String) -> AnyPublisher<[StockServiceModels.Search], URLError> {
        guard
            let urlComponents = URLComponents(string: cnbcSearch(matching: ticker))
            else { preconditionFailure("Can't create url components...") }

        guard
            let url = urlComponents.url
            else { preconditionFailure("Can't create url from url components...") }
        
        return session
                .dataTaskPublisher(for: url)
                .compactMap { [weak self] (data, response) -> [StockServiceModels.Search]? in
                    var chart: [[String:String]]?
                    do {
                        try autoreleasepool {
                            chart = try JSONDecoder().decode([[String:String]].self, from: data)
                        }
                    } catch let error {
                        chart = nil
                    }
                    
                    return chart != nil ? [StockServiceModels.Search.init(data: chart!)] : nil
                
                }.eraseToAnyPublisher()
    }
}

extension StockServiceModels {
    public struct Search: Codable {
        public enum Keys: String {
            case countryCode = "countryCode"
            case issueType = "issueType"
            case symbolName = "symbolName"
            case companyName = "companyName"
            case exchangeName = "exchangeName"
        }
        
        let data: [[String: String]]
        
        public struct Stock {
            let exchangeName: String
            let symbolName: String
            let companyName: String
        }
    }
}

extension StockServiceModels.Search.Stock {
    public func asStock(interval: SecurityInterval = .day) -> Stock {
        let open: Double = 0.0
        let high: Double = 0.0
        let low: Double = 0.0
        let close: Double = 0.0
        let volume: Double = 0.0
    
    return Stock.init(
        ticker: self.symbolName,
        date: Date(),
        open: open,
        high: high,
        low: low,
        close: close,
        volume: volume,
        changePercent: 0.0,
        changeAbsolute: 0.0,
        interval: interval,
        exchangeName: self.exchangeName,//TODO:??
        name: self.companyName,
        hasStrategy: false,
        hasPortfolio: false)
    }
}
