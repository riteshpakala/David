import Granite
import SwiftUI
import Foundation
import DavidKit

extension Playground {
    struct DidAppear: GraniteReducer {
        typealias Center = Playground.Center
        
        struct Meta: GranitePayload {
            var stocks: [Stock]
        }
        
        @Payload var meta: Meta?
        @Relay var service: StockService
        @Relay var tonalService: TonalService
        
        @Event var complete: GetRangesComplete.Reducer
        
        var thread: DispatchQueue? {
            .global(qos: .background)
        }
        
        func reduce(state: inout Center.State) {
            service.preload()
            tonalService.preload()

            let stocks = service.state.stocks["AAPL"]?["1d"] ?? []

            tonalService.center.getRangesNotifier.notify(complete)

            tonalService.center.getRanges.send(TonalService.GetRanges.Meta(stocks: stocks, days: 16))

            print("[Playground Debug] \(service.state.stocks.keys) \(stocks.count)")

            state.model = tonalService.state.model
            if state.model != nil {
                state.currentStep = .predict
            }
        }
    }
}
