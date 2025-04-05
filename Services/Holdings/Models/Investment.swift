//
//  Investment.swift
//  Stoic
//
//  Created by Ritesh Pakala Rao on 1/3/23.
//

import Foundation
import Granite
import SwiftUI
import DavidKit

public struct Investment: GraniteModel, Identifiable, Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public struct Change: GraniteModel, Identifiable, Hashable {
        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        public var id: String {
            stock.assetID + stock.date.asString
        }
        
        public let stock: Stock
        public let date: Date
        public let shares: Double
        
        public init(stock: Stock, date: Date, shares: Double) {
            self.stock = stock
            self.date = date
            self.shares = shares
        }
    }
    
    public var id: String {
        stock.name+openedDate.asStringWithTime
    }
    
    public let stock: Stock
//    var shares: [Change]//technically full history
    public var soldShares: [Change]
    public var boughtShares: [Change]
    
    public var openedDate: Date = .init()
    public var closedDate: Date? = nil
    
    public var isClosed: Bool = false
    
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
    public var currentValue: Double {
        profitValue//totalSoldValue// + ownedValue
    }
//
//    var totalValue: Double {
//        shares.map { $0.shares * $0.stock.lastValue }.reduce(0, +)
//    }
    public var totalBoughtShares: Double {
        boughtShares.map { $0.shares }.reduce(0, +)
    }
    
    public var totalBoughtValue: Double {
        boughtShares.map { $0.shares * $0.stock.lastValue }.reduce(0, +)
    }
    
    public var totalSoldShares: Double {
        soldShares.map { $0.shares }.reduce(0, +)
    }
    
    public var totalSoldValue: Double {
        soldShares.map { $0.shares * $0.stock.lastValue }.reduce(0, +)
    }
    
    public var ownedShares: Double {
        totalBoughtShares - totalSoldShares
    }
    
    public var ownedValue: Double {
        totalBoughtValue - totalSoldValue
    }
    
    public var profitValue: Double {
        totalSoldValue - totalBoughtValue
    }
    
    public var trades: Int {
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
    public var statusColor: Color {
        if totalSoldValue > totalBoughtValue {//shares.last?.stock.lastValue ?? 0 >= stock.lastValue {
            return Brand.Colors.green
        } else if trades == 0 || profitValue == 0.0 {
            return Brand.Colors.yellow
        } else {
            return Brand.Colors.red
        }
    }
    
    public mutating func update(_ stocks: [Stock]) {
//        let newShares: [Change] = stocks.map {
//            .init(stock: $0,
//                  date: $0.date,
//                  shares: currentAmount)
//        }.filter( { stock in shares.contains(where: { $0.date == stock.date }) == false } )
//
//        shares.append(contentsOf: newShares)
    }
    
    public mutating func close() {
        isClosed = true
        self.closedDate = .init()
    }
}
