//
//  Tonality.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/4/23.
//

import Foundation


public struct Tonality {
    var minDays: Int = 4
    var maxDays: Int = 28
    var idealDays: Int = 16
    
    static func scale(_ perc: Double) -> Int {
        var tonality = Tonality()
        return Int(perc * (tonality.maxDays - tonality.minDays)) + tonality.minDays
    }
}
