import Granite
import SwiftUI
import DavidKit

struct AssetDetail: GraniteNavigationDestination {
    public enum Kind: String, GraniteModel {
        case expanded
        case preview
        case floor
    }
    
    var kind: AssetDetail.Kind = .expanded
    var security: Stock? = nil
    
    @Relay var service: StockService
    @Relay var holdingsService: HoldingsService
    
    var stock: Security {
        guard let stock = self.security else {
            return Stock.empty
        }
        
        return stock
    }
    
    var stocks: [Stock] {
        guard let stock = self.security else { return [] }
        return service
            .state
            .stocks[stock.ticker]?[SecurityInterval.day.rawValue] ?? []
    }
    
    var plotData: SomePlotData {
        //TODO: last 30 days?
        let data: GraphPageViewModel.PlotData = stocks.suffix(30).map { ($0.date, $0.lastValue.asCGFloat) }
        
        return .init(data,
                     interval: .daily,
                     graphType: .price(.init(priceSize: .title2,
                                             dateSize: .headline,
                                             dateValuePadding: Brand.Padding.large,
                                             pricePadding: EdgeInsets(Brand.Padding.medium,
                                                                      Brand.Padding.medium,
                                                                      0,
                                                                      0),
                                             widthOfPriceViewIndicators: 183,
                                             widthOfPriceView: 220,
                                             info: kind == .preview ? .init(stock.ticker.uppercased()) : nil,
                                             info2: kind == .preview ? .init("owned: \((investment?.ownedShares ?? 0).display)") : nil)))
    }
    
    var stochastics: StockServiceModels.Indicators.Stochastics {
        return StockServiceModels.Indicators.init(stock, with: stocks, preview: true).stochastic
    }
    
    var investment: Investment? {
        guard let stock = self.stock as? Stock else {
            return nil
        }
        return holdingsService.state.strategy?.investmentFor(stock)
    }
    
    var ownedShares: Double {
        return investment?.ownedShares ?? 0.0
    }
    
    var plotDataStochastics: (percentK: SomePlotData, percentD: SomePlotData) {
        var dataK: GraphPageViewModel.PlotData = .init()
        var dataD: GraphPageViewModel.PlotData = .init()
        let Ks = stochastics.values.absoluteKs
        let Ds = stochastics.values.absoluteDs
        for (index) in 0..<stochastics.values.count {
            let K = Ks[index]
            let D = Ds[index]
            let date = stochastics.values.dates[index]
            
            dataK.append((date, K.asCGFloat))
            dataD.append((date, D.asCGFloat))
        }
        
        let plotDataK: SomePlotData = .init(dataK.reversed(),
                                            interval: .daily,
                                            graphType: .indicator(Brand.Colors.grey, nil))
        
        let plotDataD: SomePlotData = .init(dataD.reversed(),
                                            interval: .daily,
                                            graphType: .indicator(Brand.Colors.yellow, .init("stochastics")))
        
        return (plotDataK, plotDataD)
    }
    
    var destinationStyle: GraniteNavigationDestinationStyle {
        .customTrailing()
    }
    
    init(_ kind: Kind = .expanded, stock: Stock? = nil) {
        self.kind = kind
        self.security = stock
    }
}
