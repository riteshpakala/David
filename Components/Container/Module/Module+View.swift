//
//  Window+View.swift
//  Stoic
//
//  Created by Ritesh Pakala Rao on 12/20/22.
//

import Foundation
import Granite
import SwiftUI

extension Module: View {
    var view: some View {
        VStack {
            switch state.config.kind {
            case .topVolume(let securityType),
                 .winners(let securityType),
                 .losers(let securityType),
                 .winnersAndLosers(let securityType):
                AssetSection(context: state.config.kind,
                             securityType)
            case .portfolio:
                Portfolio()
            case .special:
                Special()
            case .debug:
                Debug()
            default:
                EmptyView.init()
            }
        }
    }
}
