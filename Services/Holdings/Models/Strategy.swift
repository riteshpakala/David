//
//  Strategy.swift
//  Stoic
//
//  Created by Ritesh Pakala Rao on 1/3/23.
//

import Foundation
import Granite
import SwiftUI
import DavidKit

struct Strategy: GraniteModel, Identifiable {
    var id: String {
        .init("\(startDate.millisecondsSince1970)")
    }
    
    struct Change: GraniteModel {
        let date: Date
        let value: Double
    }
    
    var investments: [Investment]
    var startDate: Date
    
    var value: Double {
        return investments.map { $0.currentValue }.reduce(0, +)
    }
    
    var closingValue: Double = 0.0
    var startingValue: Double
    var valueChanges: [Change]
    
    public init(value: Double) {
        investments = []
        startDate = .today
        self.startingValue = value
        valueChanges = [.init(date: .today, value: value)]
    }
    
    var lastChange: Change {
        valueChanges.sorted(by: { $0.date.compare($1.date) == .orderedDescending }).first ?? .init(date: .today, value: value)
    }
    
    var currentChange: Double {
        ((value - startingValue) / startingValue).format(4)
    }
    
    var closingChange: Double {
        ((closingValue - startingValue) / startingValue).format(4)
    }
    
    var currentChangeDisplay: LocalizedStringKey {
        .init("\(isGaining ? "+" : "-")\(currentChange)%")
    }
    
    var isGaining: Bool {
        currentChange >= 0
    }
    
    var colorScheme: Color {
        isGaining ? Brand.Colors.green : Brand.Colors.red
    }
    
    var colorClosingScheme: Color {
        closingValue > startingValue ? Brand.Colors.green : Brand.Colors.red
    }
    
    var trades: Int {
        investments.map { $0.trades }.reduce(0, +)
    }
    
    var age: Int {
        Date.today.daysFrom(startDate)
    }
    
    var ageDisplay: String {
        "age: \(age) \(age == 1 ? "day" : "days")"
    }
    
    func investmentFor(_ stock: Stock) -> Investment? {
        investments.first(where: { $0.stock.assetID == stock.assetID })
    }
}
