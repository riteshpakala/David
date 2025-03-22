//
//  TickerSearch.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/4/23.
//

import Foundation
import Granite

struct TickerSearch: GraniteModel {
    var symbol: String
    var name: String
    var lastsale: String
    var netchange: String
    var pctchange: String
    var volume: String
    var marketCap: String
    var country: String
    var ipoyear: String
    var industry: String
    var sector: String
    var url: String
    var exchange: String?
    
    mutating func updateExchange(_ value: String) {
        self.exchange = value
    }
}

class TickerSearchManager {
    static var shared = TickerSearchManager()
    
    var allTickers: [TickerSearch] = []
    var tickerDict: [String:[TickerSearch]] = [:]
    var loading: Bool = false
    var loaded: Bool = false
    
    func load() {
        guard loading == false else { return }
        loading = true
        DispatchQueue.global(qos: .utility).async {
            guard let urlNasdaq = Bundle.main.url(forResource: "nasdaq_full_tickers", withExtension: "json"),
                  let urlNYSE = Bundle.main.url(forResource: "nyse_full_tickers", withExtension: "json"),
                  let urlAMEX = Bundle.main.url(forResource: "amex_full_tickers", withExtension: "json") else {
                return
            }
            
            guard let dataNasdaq = try? Data(contentsOf: urlNasdaq) else {
                return
            }
            
            guard let dataNYSE = try? Data(contentsOf: urlNYSE) else {
                return
            }
            
            guard let dataAMEX = try? Data(contentsOf: urlAMEX) else {
                return
            }
            
            var start = CFAbsoluteTimeGetCurrent()
            do {
                let tickersNasdaq = try JSONDecoder().decode([TickerSearch].self, from: dataNasdaq)
                
                let tickersNYSE = try JSONDecoder().decode([TickerSearch].self, from: dataNYSE)
                
                let tickersAMEX = try JSONDecoder().decode([TickerSearch].self, from: dataAMEX)
                
                guard self.loaded == false else { return }
                
                print("[TickerSearchManager] loaded decode(\(self.allTickers.count)): \(CFAbsoluteTimeGetCurrent() - start)")
                
                self.loaded = true
                
                start = CFAbsoluteTimeGetCurrent()
                
                self.insertTicker("NASDAQ", tickers: tickersNasdaq)
                self.insertTicker("NYSE", tickers: tickersNYSE)
                self.insertTicker("AMEX", tickers: tickersAMEX)
                
                print("[TickerSearchManager] bucketed : \(CFAbsoluteTimeGetCurrent() - start)")
            } catch let error {
                
            }
        }
    }
    
    func insertTicker(_ value: String, tickers: [TickerSearch]) {
        for ticker in tickers {
            var mutableTicker = ticker
            guard let fChar = ticker.symbol.first else { continue }
            let startingLetter = String(fChar).capitalized
            mutableTicker.updateExchange(value)
            if self.tickerDict[startingLetter] == nil {
                self.tickerDict[startingLetter] = [mutableTicker]
            } else {
                self.tickerDict[startingLetter]?.append(mutableTicker)
            }
            self.allTickers.append(mutableTicker)
        }
    }
    
    func search(_ value: String) -> [TickerSearch] {
        guard let fChar = value.first else { return [] }
        let tickers = self.tickerDict[String(fChar).capitalized] ?? []
        
        let suggestions: [TickerSearch] = tickers.filter {
            
            let range = $0.symbol.uppercased().range(of: value.uppercased())
            
            if let rangeCheck = range {
                return rangeCheck.lowerBound == $0.symbol.startIndex
            } else {
                
                let rangeCompany = $0.name.uppercased().range(of: value.uppercased())
                
                if let rangeCompanyCheck = rangeCompany {
                    return rangeCompanyCheck.lowerBound == $0.name.startIndex
                } else {
                    return false
                }
            }
        }
        
        return suggestions
    }
}

/*
 func suggestions(_ options: [String]) -> [String] {
         guard self.count > 1 else  { return [] }
         
         let text = self
         
         let textAfterCommand: String
         
         if text.hasPrefix("/") {
             textAfterCommand = String(text[text.index(after: text.startIndex)...])
         } else {
             textAfterCommand = text
         }

         let isUppercased: Bool = textAfterCommand.first?.isUppercase == true
        
         let suggestions: [String] = options
             .filter {
                 let range = $0.lowercased().range(of: textAfterCommand.lowercased())
                 
                 if let rangeCheck = range {
                     return rangeCheck.lowerBound == $0.startIndex
                 } else {
                     return false
                 }
                 
             }.map {
                 if isUppercased {
                     return ("/"+$0).capitalized
                 } else {
                     return ("/"+$0).lowercased()
                 }
             }
         
         return suggestions
     }

 
 
 
 
 
 */
