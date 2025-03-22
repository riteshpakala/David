//
//  Categories.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala Rao on 12/21/20.
//

import Foundation

public enum CategoryType {
    case savedModels
    case publicModels
    case holdings
    case recentlyViewed
    case topVolume
    case gainers
    case losers
}

public enum CategoryScope {
    case global
    case local
}

protocol Category: Asset {
    
}
