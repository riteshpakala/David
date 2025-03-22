//
//  StockServiceClient.swift
//  * stoic
//
//  Created by Ritesh Pakala Rao on 12/22/20.
//

import Foundation
import Granite
import Combine

public class StockServiceClient: GraniteModel {
    public static func == (lhs: StockServiceClient, rhs: StockServiceClient) -> Bool {
        lhs.id == rhs.id
    }
    
    public func encode(to encoder: Encoder) throws {
        
    }
    
    public required init(from decoder: Decoder) throws {
        session = .shared
    }
    
    let id: UUID = .init()
    
    internal let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public enum Exchanges: String {
        case nasdaq
        case nyse
    }
    
    public func yahooV7(matching ticker: String, from pastEpoch: String, to futureEpoch: String) -> String {
        return "https://query1.finance.yahoo.com/v7/finance/download/\(ticker)?period1=\(pastEpoch)&period2=\(futureEpoch)&interval=1h&events=history"
    }
    
    public func yahooV8Recent(matching ticker: String) -> String {
        return "https://query1.finance.yahoo.com/v8/finance/chart/\(ticker)?region=US&lang=en-US&includePrePost=true&interval=1h&range=\("120d")&corsDomain=finance.yahoo.com&.tsrc=finance"
    }
    
    public func yahooV8(matching ticker: String, from pastEpoch: String, to futureEpoch: String, interval: SecurityInterval) -> String {
        return "https://query1.finance.yahoo.com/v8/finance/chart/\(ticker)?period1=\(pastEpoch)&period2=\(futureEpoch)&region=US&lang=en-US&includePrePost=true&interval=\(interval.rawValue)&corsDomain=finance.yahoo.com&.tsrc=finance"
    }
    
    public func cnbcSearch(matching ticker: String) -> String {
        return "https://symlookup.cnbc.com/symservice/symlookup.do?prefix=\(ticker)&partnerid=20064&pgok=1&pgsize=50"
    }
    
    public func tradingDays(month: String,
                            year: String) -> String {
        return "https://api.tradier.com/v1/markets/calendar?month=\(month)&year=\(year)"
    }
    
    public var quotesStoic: String {
        "https://wzda7iwzjd.execute-api.us-west-1.amazonaws.com/default/stoic-search"
    }
    
    public var quotesYahoo: String {
        "https://apidojo-yahoo-finance-v1.p.rapidapi.com/market/v2/get-quotes"
    }
    
    var movers: String {
        "https://apidojo-yahoo-finance-v1.p.rapidapi.com/market/v2/get-movers"
    }
}

public struct StockServiceModels {
    
}
