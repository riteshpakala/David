//
//  Special+View.swift
//  Stoic
//
//  Created by Ritesh Pakala Rao on 12/20/22.
//

import Foundation
import Granite
import SwiftUI

extension Special: View {
    var view: some View {
        VStack {
            state.scene.onAppear(perform: {
                state.scene.run()
            }).onDisappear(perform: {
                //state.scene.clear()
            })
        }
    }
}
