//
//  StockRequests.Search.swift
//  Stoic
//
//  Created by Ritesh Pakala Rao on 1/3/23.
//

import Foundation
import Granite

extension Requests.Stock {
    struct Search : Request {
        typealias Response = [[String: String]]
        
        enum CodingKeys: CodingKey {
            
        }
        
        var path: String { "https://symlookup.cnbc.com/symservice/symlookup.do" }
        
        var method: RequestMethod { .get }
        
        var query: String
        
        init(query: String) {
            self.query = query
        }
        
        var ignoresEndpoint: Bool {
            true
        }
        
        var customQueries: [String : String] {
            [
                "prefix" : query,
                "partnerid" : "20064",
                "pgok" : "1",
                "pgsize" : "24"
            ]
        }
    }
}

extension Requests.Stock.Search {
    public struct SearchResponse: Codable {
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
