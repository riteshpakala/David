import Granite
import SwiftUI
import DavidKit

extension Playground {
    
    enum Step: GraniteModel {
        case search
        case tune
        case generate
        case training
        case predict
    }
    
    enum PredictionState: GraniteModel {
        case predicting
        case complete
        case none
    }
    
    struct Center: GraniteCenter {
        struct State: GraniteState {
//            @Geometry var geometry: GeometryProxy?
            var currentStep: Step = .search
            var predictionState: PredictionState = .none
            
            var stock: Stock? = nil
            var stocks: [Stock] = []
            var tonalRanges: [TonalRange] = []
            
            var baseTonalRange: TonalRange? = nil
            
            var selectedTonalRange: TonalRange? = nil
            
            var selectedOutput: StockServiceModels.Indicators.Context = .close
            
            var outputChoices: [StockServiceModels.Indicators.Context] = [.low, .close, .high]
            
            var indicatorChoices: [StockServiceModels.Indicators.Variant] = StockServiceModels.Indicators.Variant.nonDefaults
            var selectedIndicators: [StockServiceModels.Indicators.Variant] = [.stochk, .macdsignal]
            
            var indicator1: String = ""
            
            var isAnimating: Bool = false
            
            var trainingProgress: CGFloat = 0
            
            var daysPercent: Double = 0.5
            
            var days: Int = 16
            
            var temperature: CGFloat = 0.5
            var temperatureX: CGFloat = 0.5
            var temperatureY: CGFloat = 0.5
            
            var model: SVMModel? = nil
            
            var prediction: Double = 0.0
            var predictionIsGainer: Bool = false
        }
        
        //@Event(.onAppear) var didAppear: Playground.DidAppear.Reducer
        @Event var assetSelected: Playground.AssetSelected.Reducer
        @Event var getRanges: Playground.GetRanges.Reducer
        @Event var getRangesComplete: Playground.GetRangesComplete.Reducer
        @Event var prepareToTrain: Playground.PrepareToTrain.Reducer
        @Event var train: Playground.Train.Reducer
        @Event var trainCancel: Playground.TrainCancel.Reducer
        @Event var setTemperature: Playground.SetTemperature.Reducer
        @Event var predict: Playground.Predict.Reducer
        
        @Store public var state: State
        
        struct TrainingIndicator: GraniteModel, Identifiable {
            let id: UUID = .init()
            
            let kind: StockServiceModels.Indicators.Kind
        }
    }
}
