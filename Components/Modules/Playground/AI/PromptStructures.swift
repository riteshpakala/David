//
//  PromptStructures.swift
//  Stoic
//
//  Created by Ritesh Pakala on 7/7/23.
//

import Foundation

struct TimeSeriesDataPoint: Codable {
    let date: Date
    let open: Double
    let high: Double
    let low: Double
    let close: Double
    let volume: Double
    let changePercent: Double
    let changeAbsolute: Double
}

extension Stock {
    var asTimeSeriesData: TimeSeriesDataPoint {
        .init(date: self.date,
              open: self.open,
              high: self.high,
              low: self.low,
              close: self.close,
              volume: self.volume,
              changePercent: self.changePercent,
              changeAbsolute: self.changeAbsolute)
    }
}
