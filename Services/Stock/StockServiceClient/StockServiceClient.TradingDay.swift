//
//  StockService.TradingDay.swift
//  * stoic
//
//  Created by Ritesh Pakala Rao on 1/19/21.
//

import Foundation
import Combine
import Granite

extension StockServiceClient {
    public func getTradingDays(month: String, year: String) -> AnyPublisher<[StockServiceModels.TradingDay], URLError> {
        guard
            let urlComponents = URLComponents(string: tradingDays(month: month, year: year))
            else { preconditionFailure("Can't create url components...") }

        guard
            let url = urlComponents.url
            else { preconditionFailure("Can't create url from url components...") }
        
        return session
                .dataTaskPublisher(for: url)
                .compactMap { [weak self] (data, response) -> [StockServiceModels.TradingDay] in
                    
                    var tradingDays: [StockServiceModels.TradingDay] = []
                    if let content = String(data: data, encoding: .utf8) {
                        let contentSplitStep1 = content.components(separatedBy: "</status>")
                        
                        for contentSplit in contentSplitStep1 {
                            if let lastItem = contentSplit.components(separatedBy: "<date>").last {
                                let dateAndStatusSplit = lastItem.components(separatedBy: "</date><status>")
                                if  dateAndStatusSplit.count > 1,
                                    let dateString = dateAndStatusSplit.first,
                                    let status = dateAndStatusSplit.last {
                                    if let date = dateString.asDate() {
                                        let isOpen: Bool = status == "open" ? true : false
                                        
                                        tradingDays.append(.init(date: date, isOpen: isOpen))
                                    }
                                    
                                }
                            }
                        }
                    }
                    
                    return tradingDays
                
                }.eraseToAnyPublisher()
    }
}

extension StockServiceModels {
    public struct TradingDay: Codable {
        let date: Date
        let isOpen: Bool
    }
}
