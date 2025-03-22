//
//  Portfolio.SyncingView.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/4/23.
//

import Foundation
import SwiftUI
import Granite

extension Portfolio {
    var syncingView: some View {
        ZStack {
            Brand.Colors.black.opacity(0.75)
                .ignoresSafeArea()
                .offset(y: 8)
            VStack {
                Spacer()
                
                GraniteText("Syncing",
                            .headline,
                            .bold)
                .frame(width: 70,
                       height: 25)
                .applyGradient(selected: true,
                               colors: [Brand.Colors.marbleV2.opacity(0.66),
                                        Brand.Colors.marble])
                .padding(.bottom, Brand.Padding.medium)
                
                ProgressView()
                    .scaleEffect(1.2)
                    .padding(.top, 8)
                    .padding(.bottom, 12)
                
                
                Spacer()
            }
        }
    }
}
