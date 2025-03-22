//
//  Investment.swift
//  Stoic
//
//  Created by Ritesh Pakala Rao on 1/3/23.
//

import Foundation
import Granite
import SwiftUI

struct Investment: GraniteModel, Identifiable, Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    struct Change: GraniteModel, Identifiable, Hashable {
        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        var id: String {
            stock.assetID + stock.date.asString
        }
        
        let stock: Stock
        let date: Date
        let shares: Double
    }
    
    var id: String {
        stock.name+openedDate.asStringWithTime
    }
    
    let stock: Stock
//    var shares: [Change]//technically full history
    var soldShares: [Change]
    var boughtShares: [Change]
    
    var openedDate: Date = .init()
    var closedDate: Date? = nil
    
    var isClosed: Bool = false
    
//    var initialAmount: Double {
//        shares.first?.shares ?? 0
//    }
//
//    var currentAmount: Double {
//        shares.last?.shares ?? 0
//    }
//
//    var lastChangeValue: Double {
//        shares.last?.stock.lastValue ?? 0.0
//    }
//
//    var lastChangePercent: Double {
//        shares.last?.stock.changePercent ?? 0.0
//    }
//
//    var lastChangeDate: Date {
//        shares.last?.stock.date ?? .today
//    }
//
//    var changePercent: Double {
//        ((shares.last?.stock.lastValue ?? 0.0) - stock.lastValue) / stock.lastValue
//    }
    
    //Use sold, because sale is final price
    var currentValue: Double {
        profitValue//totalSoldValue// + ownedValue
    }
//
//    var totalValue: Double {
//        shares.map { $0.shares * $0.stock.lastValue }.reduce(0, +)
//    }
    var totalBoughtShares: Double {
        boughtShares.map { $0.shares }.reduce(0, +)
    }
    
    var totalBoughtValue: Double {
        boughtShares.map { $0.shares * $0.stock.lastValue }.reduce(0, +)
    }
    
    var totalSoldShares: Double {
        soldShares.map { $0.shares }.reduce(0, +)
    }
    
    var totalSoldValue: Double {
        soldShares.map { $0.shares * $0.stock.lastValue }.reduce(0, +)
    }
    
    var ownedShares: Double {
        totalBoughtShares - totalSoldShares
    }
    
    var ownedValue: Double {
        totalBoughtValue - totalSoldValue
    }
    
    var profitValue: Double {
        totalSoldValue - totalBoughtValue
    }
    
    var trades: Int {
        boughtShares.count + soldShares.count
    }
    
//    var profitMargin: (profit: Double, marginAvg: Double) {
//        let soldDates = soldShares.map { $0.stock.date }
//        let bought = shares.filter { soldDates.contains($0.stock.date) }
//
//        var totalProfit: Double = 0.0
//        var margins: [Double] = []
//        for soldShare in soldShares {
//            if let boughtShare = bought.first(where: { $0.date == soldShare.date }) {
//                let margin = soldShare.stock.lastValue - boughtShare.stock.lastValue
//                totalProfit += margin
//                margins.append(margin)
//            }
//        }
//        let avgMargin = margins.reduce(0, +) / Double(margins.count)
//
//        return (totalProfit, avgMargin.isNaN ? 0.0 : avgMargin)
//    }
    
    //TODO: something is wrong with this logic
    var statusColor: Color {
        if totalSoldValue > totalBoughtValue {//shares.last?.stock.lastValue ?? 0 >= stock.lastValue {
            return Brand.Colors.green
        } else if trades == 0 || profitValue == 0.0 {
            return Brand.Colors.yellow
        } else {
            return Brand.Colors.red
        }
    }
    
    mutating func update(_ stocks: [Stock]) {
//        let newShares: [Change] = stocks.map {
//            .init(stock: $0,
//                  date: $0.date,
//                  shares: currentAmount)
//        }.filter( { stock in shares.contains(where: { $0.date == stock.date }) == false } )
//
//        shares.append(contentsOf: newShares)
    }
    
    mutating func close() {
        isClosed = true
        self.closedDate = .init()
    }
}
