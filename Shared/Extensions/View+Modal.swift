//
//  View+Modal.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/5/23.
//

import Foundation
import SwiftUI

extension View {
    @MainActor
    func disclaimer(_ text: String) -> some View {
        self.onTapGesture {
            ModalService.shared.present(GraniteAlertView(message: .init(text)) {
                
                GraniteAlertAction(title: "done")
            })
        }
    }
}
