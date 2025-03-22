//
//  PlaygroundDataSet.swift
//  Stoic
//
//  Created by Ritesh Pakala Rao on 4/30/23.
//

import Foundation
import Granite
//MARK: -- DataSet without no sentiment
struct TonalityDataSet {
    let security: Security
    
    var indicators: StockServiceModels.Indicators
    let predicting: Bool
    let context: StockServiceModels.Indicators.Context
    init(_ indicators: StockServiceModels.Indicators,
         context: StockServiceModels.Indicators.Context = .close,
         predicting: Bool = false) {
        
        self.security = indicators.security
        self.indicators = indicators
        self.predicting = predicting
        self.context = context
    }

    public var asArray: [Double] {
        [
            indicators.emaWA(context: context),
            indicators.macD(context:  context),
            indicators.macDPreviousSignal(context: context),
            indicators.smaWA(context:  context),
            indicators.avgVolChange(),
            indicators.vwa(),
        ]
    }
    
    public func asArrayIMBHS(_ variant1: StockServiceModels.Indicators.Variant,
                             _ variant2: StockServiceModels.Indicators.Variant,
                             days1: Int,
                             days2: Int,
                             days0: Int) -> IMBHSDataPoint {
        
        let variant1Computed = variant1.compute(indicators, context: context, days: days1)
        let variant2Computed = variant2.compute(indicators, context: context, days: days2)
        
        let default1Computed = StockServiceModels
            .Indicators
            .Variant
            .volatility
            .compute(indicators,
                     context: context,
                     days: days0)
        let default2Computed = StockServiceModels
            .Indicators
            .Variant
            .momentum
            .compute(indicators,
                     context: context,
                     days: days0)
        let default3Computed = StockServiceModels
            .Indicators
            .Variant
            .change
            .compute(indicators,
                     context: context,
                     days: days0)
        let default4Computed = StockServiceModels
            .Indicators
            .Variant
            .vwa
            .compute(indicators,
                     context: context,
                     days: days0)
        
        var dataPoint: IMBHSDataPoint = .init(security: indicators.security as? Stock,
                                              variant1: variant1,
                                              variant2: variant2,
                                              variant1Computed: variant1Computed,
                                              variant2Computed: variant2Computed,
                                              default1Computed: default1Computed,
                                              default2Computed: default2Computed,
                                              default3Computed: default3Computed,
                                              default4Computed: default4Computed,
                                              days0: days0,
                                              days1: days1,
                                              days2: days2)
        
        return dataPoint
    }

    public var inDim: Int {
        asArray.count
    }

    public var outDim: Int {
        output.count
    }

    public var output: [Double] {
        switch context {
        case .close:
            return [security.lastValue]
        case .low:
            return [security.lowValue]
        case .high:
            return [security.highValue]
        }
    }

    public var description: String {
        let desc: String =
            """
            💽💽💽💽💽💽💽💽💽💽💽💽💽
            '''''''''''''''''''''''''''''
            [ Security Data Set - \(security.securityType) - \(security.date.asString) ]
            Value: \(security.lastValue)
            Change: \(security.changePercentValue)
            Volume: \(security.volumeValue)
            - Previous Data Set - \(indicators.basePair.previous.date.asString)
            Value: \(indicators.basePair.previous.lastValue)
            Change: \(indicators.basePair.previous.changePercentValue)
            Volume: \(indicators.basePair.previous.volumeValue)
            ----
            \(indicators.averagesToString)
            \(indicators.stochastic.values.toString)
            Previus stoichs:
            \(indicators.stochasticPreviousDay.values.toString)
            MacD_Close: \(indicators.macD(context: .close))
            MacDSig_Close: \(indicators.macDSignal(context: .close))
            ema12: \(indicators.ema(12, context: .close))
            ema26: \(indicators.ema(26, context: .close))
            '''''''''''''''''''''''''''''
            💽
            """
        return desc
    }
    
    public var inputDescription: String {
        let desc: String =
            """
            💽💽💽💽💽💽💽💽💽💽💽💽💽
            '''''''''''''''''''''''''''''
            [ Security Data Set - \(security.securityType)  ]
            
            \(indicators.basePair.base.date.asString) ----
            \(indicators.averagesToString)
            '''''''''''''''''''''''''''''
            💽
            """
        return desc
    }
}

struct IMBHSDataPoint: GraniteModel {
    var security: Stock?
    
    var variant1: StockServiceModels.Indicators.Variant
    var variant2: StockServiceModels.Indicators.Variant
    
    var variant1Computed: Double
    var variant2Computed: Double
    
    var default1Computed: Double
    var default2Computed: Double
    var default3Computed: Double
    var default4Computed: Double
    
    var days0: Int
    var days1: Int
    var days2: Int
    
    var asOutput: [Double] {
        [
            variant1Computed,
            variant2Computed,
            default1Computed,
            default2Computed,
            default3Computed,
            default4Computed,
            days1.asDouble,
            days2.asDouble,
            days0.asDouble
        ]
    }
    
    public var description: String {
        let desc: String =
            """
            🎵🎵🎵🎵🎵🎵🎵🎵🎵🎵🎵🎵🎵🎵
            '''''''''''''''''''''''''''''
            [ IMBHS DP - \(security?.symbol) - \(security?.date.asString) ]
            Value: \(security?.lastValue)
            ----
            \(variant1): \(variant1Computed.display) @ \(days1) days
            \(variant2): \(variant2Computed.display) @ \(days2) days
            ----
            volatility: \(default1Computed.display) @ \(days0) days
            momentum:   \(default2Computed.display) @ \(days0) days
            change:     \(default3Computed.display) @ \(days0) days
            vwa:        \(default4Computed.display) @ \(days0) days
            '''''''''''''''''''''''''''''
            🎵
            """
        return desc
    }
}
