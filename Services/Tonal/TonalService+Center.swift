import Granite
import SwiftUI

extension TonalService {
    struct Center: GraniteCenter {
        
        struct State: GraniteState {
            var model: SVMModel? = nil
            var tonalRange: TonalService.GetRanges.Result? = nil
        }
        
        @Store(persist: "persistence.tonal.0001", autoSave: true) public var state: State
        
        @Event public var generate: Generate.Reducer
        @Event public var getRanges: GetRanges.Reducer
        
        @Notify(Generate.self) public var generateNotifier
        @Notify(GetRanges.self) public var getRangesNotifier
    }
}
