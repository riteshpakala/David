//
//  TonalRange.swift
//  Stoic
//
//  Created by Ritesh Pakala on 5/2/23.
//
import Granite
import SwiftUI
import Foundation

extension Array where Element == Stock {
    func baseRange() -> TonalRange {
        
        let similarities: [TonalSimilarity] = self.map { TonalSimilarity.init(date: $0.date, similarity: 1.0) }
        
        let indicators: [TonalIndicators] = self.map { TonalIndicators.init(date: $0.date, volatility: 1.0, volatilityCoeffecient: 1.0) }
        
        return .init(objects: self,
                     self,
                     similarities,
                     indicators,
                     base: true)
    }
    
    func expanded(from chunk: [Stock]) -> [Stock] {
        let sortedChunk = (chunk.sortDesc as? [Stock]) ?? []
        let ordered = (self.sortDesc as? [Stock]) ?? []
        
        if let lastSecurity = sortedChunk.last,
           let lastSecurityIndex = ordered.firstIndex(where: { $0.isEqual(to: lastSecurity) } ),
           lastSecurityIndex + 1 < ordered.count {
            
            let expandedChunk = sortedChunk + [ordered[lastSecurityIndex+1]]
            
            return expandedChunk
        } else {
            return chunk
        }
    }
}

public struct TonalRange: GraniteModel, Identifiable, Hashable {
    public static func == (lhs: TonalRange, rhs: TonalRange) -> Bool {
        lhs.id == rhs.id &&
        lhs.similarities == rhs.similarities &&
        lhs.indicators == rhs.indicators
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public var id: UUID = .init()
    
    enum CodingKeys: CodingKey {
        case base
        case objects
        case similarities
        case indicators
        case expanded
    }
    
    let base: Bool
    let objects: [Stock]
    let similarities: [TonalSimilarity]
    let indicators: [TonalIndicators]
    let expanded: [Stock]
    
    var sentimentShifted: [Security] {
        expanded.enumerated().filter( { $0.offset != 0 }).map { $0.element }
    }
    
    public init(
        objects: [Stock],
        _ expanded: [Stock],
        _ similarities: [TonalSimilarity],
        _ indicators: [TonalIndicators],
        base: Bool = false) {
        
        self.objects = objects
        self.expanded = expanded
        self.similarities = similarities
        self.indicators = indicators
        self.base = base
    }
    
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//
//        try container.encode(base, forKey: .base)
//        try container.encode(similarities, forKey: .similarities)
//        try container.encode(indicators, forKey: .indicators)
//    }
//
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//    }
    
    var dates: [Date] {
        let objectDates: [Date] = objects.map { $0.date }
        return objectDates.sorted(by: { $0.compare($1) == .orderedDescending })
    }
    
    var datesExpanded: [Date] {
        let objectDates: [Date] = expanded.map { $0.date }
        return objectDates.sorted(by: { $0.compare($1) == .orderedDescending })
    }
    
    func similarity(for date: Date) -> TonalSimilarity {
        return similarities.first(where: { $0.date == date }) ?? .empty
    }
    
    func indicator(for date: Date) -> TonalIndicators {
        return indicators.first(where: { $0.date == date }) ?? .empty
    }
    
    var dateInfoShort: String {
        return "\((dates.first ?? Date.today).asString) - \((dates.last ?? Date.today).asString)"
    }
    
    var dateInfoShortDisplay: String {
        return "\((dates.first ?? Date.today).asString)\n-\n\((dates.last ?? Date.today).asString)"
    }
    
    var avgSimilarity: Double {
        return similarities.map({ $0.similarity }).reduce(0, +)/similarities.count.asDouble
    }
    
    var avgSimilarityDisplay: String {
        return base ? "Present" : "\((avgSimilarity*100).asInt)% Similar"
    }
    
    var avgSimilarityColor: Color {
        base ? Brand.Colors.yellow : (avgSimilarity > 0.6 ? Brand.Colors.green : (avgSimilarity > 0.4 ? Brand.Colors.yellow : Brand.Colors.red))
    }
    
    public static var empty: TonalRange {
        return .init(objects: [], [], [], [])
    }
}

extension TonalRange {
    var ticker: String {
        objects.first?.ticker ?? "error-ticker"
    }
    var symbol: String {
        "$" + (objects.first?.ticker ?? "error-ticker")
    }
}

public struct TonalSimilarity: GraniteModel, Hashable {
    let date: Date
    let similarity: Double
    
    public static var empty: TonalSimilarity {
        return .init(date: Date.today, similarity: 0.0)
    }
}

public struct TonalIndicators: GraniteModel, Hashable {
    let date: Date
    let volatility: Double
    let volatilityCoeffecient: Double
    
    public static var empty: TonalIndicators {
        return .init(date: Date.today, volatility: 0.0, volatilityCoeffecient: 0.0)
    }
}
