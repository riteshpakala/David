//
//  WheelView.swift
//  Stoic
//
//  Created by Ritesh Pakala on 7/6/23.
//

import Foundation
import SwiftUI

struct PickerView: View {
    @Binding var mutate: Int
    @State var digit: Int = 0
    
    var width: CGFloat = 36
    
    
    let options: [Int]
    
    
    var body: some View {
        Picker(.init(""), selection: $digit) {
            ForEach(options, id: \.self) { number in
                GraniteText("\(number)")
            }
        }
        .pickerStyle(.wheelAutomatic)
        .frame(width: width)
        .clipped()
        .onChange(of: digit) { value in
            mutate = value
        }
    }
}

extension PickerStyle where Self == DefaultPickerStyle {
    #if os(macOS)
    static var wheelAutomatic: DefaultPickerStyle {
        return .automatic
    }
    #else
    static var wheelAutomatic: WheelPickerStyle {
        return .wheel
    }
    #endif
}
