import Granite
import CoreGraphics

extension Playground {
    struct GetRanges: GraniteReducer {
        typealias Center = Playground.Center
        
        struct Meta: GranitePayload {
            var stocks: [Stock]
        }
        
        @Payload var meta: Meta?
        
        @Relay var tonalService: TonalService
        @Event var complete: GetRangesComplete.Reducer
        
        func reduce(state: inout Center.State) {
            guard let meta = self.meta else { return }
            let newDays: Int = Tonality.scale(state.daysPercent)
            
            state.days = newDays
            
            tonalService.center.getRangesNotifier.notify(complete)
            tonalService.center.getRanges.send(TonalService.GetRanges.Meta(stocks: meta.stocks, days: newDays))
        }
    }
    
    struct GetRangesComplete: GraniteReducer {
        typealias Center = Playground.Center
        
        @Relay var service: TonalService
        
        @Payload var meta: TonalService.GetRanges.Meta?
        
        func reduce(state: inout Center.State) {
            guard let meta = self.meta else { return }
            service.preload()
            
            state.stocks = meta.stocks
            
            guard let lastStock = meta.stocks.last else { return }
            
            //state.currentStep = .tune
            state.days = meta.days
            state.stock = lastStock
            state.stocks = meta.stocks
            state.tonalRanges = service.state.tonalRange?.ranges ?? []
            state.selectedTonalRange = service.state.tonalRange?.ranges.first
            state.baseTonalRange = service.state.tonalRange?.ranges.first
            state.currentStep = .tune
        }
    }
    
    struct PrepareToTrain: GraniteReducer {
        typealias Center = Playground.Center
        
        @Relay var service: TonalService
        
        @Payload var meta: TonalService.GetRanges.Meta?
        
        func reduce(state: inout Center.State) {
            state.currentStep = .generate
        }
    }
    
    struct Train: GraniteReducer {
        typealias Center = Playground.Center
        
        @Relay var service: TonalService
        
        @Event var progress: TrainProgress.Reducer
        
        func reduce(state: inout Center.State) {
            guard let tonalRange = state.selectedTonalRange else { return }
            
            var trainingText: String = """
            \(state.stocks.count) stocks
            \(tonalRange.dates.count) dates
            \(state.selectedTonalRange?.dateInfoShortDisplay)
            indicators: \(state.selectedIndicators)
            """
            
            print(trainingText)
            //TODO: Issue#1 in Granite
            //state.currentStep = .training
            TonalGenerateRemote.shared.cancel = false
            
            guard state.selectedIndicators.count >= 2 else { return }
            let variant1 = state.selectedIndicators[0]
            let variant2 = state.selectedIndicators[1]
            
            
            service
                .center
                .generate
                .send(TonalService
                    .Generate
                    .Meta(stocks: state.stocks,
                          range: tonalRange,
                          progressReducer: progress,
                          days: state.days,
                          context: state.selectedOutput,
                          variant1: variant1,
                          variant2: variant2))
        }
    }
    
    struct TrainProgress: GraniteReducer {
        typealias Center = Playground.Center
        
        @Relay var service: TonalService
        
        @Payload var meta: TonalService.Generate.MetaResult?
        
        func reduce(state: inout Center.State) {
            guard let meta = self.meta else { return }
            
            var progressText: String = """
            \(meta.daysIndex)/\(meta.days) progress
            \(meta.training ? "(training)" : "")
            \(meta.complete ? "(complete) \(service.state.model == nil)" : "")
            """
            
            if meta.training == false {
                state.trainingProgress = CGFloat(meta.daysIndex) / CGFloat(meta.days)
            }
            
            print(progressText)
            if meta.complete {
                if let model = meta.model {
                   state.model = model
                }

                state.prediction = 0.0
                state.temperatureX = 0.5
                state.temperatureY = 0.5
                
                state.trainingProgress = 0
                state.currentStep = .predict
            }
        }
    }
    
    struct TrainCancel: GraniteReducer {
        typealias Center = Playground.Center
        
        func reduce(state: inout Center.State) {
            TonalGenerateRemote.shared.cancel = true
            state.trainingProgress = 0
            state.currentStep = .generate
        }
    }
}
