//
//  Portfolio.WalletPicker.swift
//  Stoic (iOS)
//
//  Created by Ritesh Pakala on 6/2/23.
//

import Foundation
import Granite
import SwiftUI

//TODO: move to a more general location?
#if os(iOS)
extension UIPickerView {
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric , height: 84)
    }
}
#endif

extension Portfolio {
    var wallet: some View {
        HStack {
            
            GraniteText(.init("Wallet: " + (service.state.isStrategyLive ? "$\((service.state.wallet.current).display)" : service.state.wallet.joined)))
                .addInfoIcon(text: "This is where you can set your starting investment capital. It will be disabled when you begin. Reset your trading strategy to re-adjust your starting capital.")
                .padding(.leading, 6)
            
            Spacer()
            
            if service.state.isStrategyLive {
                Image(systemName: "lock.fill")
                    .frame(width: 14, height: 14)
                    .foregroundColor(Brand.Colors.marbleV2)
            } else {
                
                Button(action: {
                    ModalService
                        .shared
                        .present(GraniteAlertView(mode: .sheet) {
                        GraniteAlertAction {
                            walletPicker
                                .frame(height: 66)
                        }
                        
                        GraniteAlertAction(title: "done")
                    })
                }) {
                    GraniteText("edit",
                                Brand.Colors.marbleV2)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }.frame(height: 24)
    }
    
    var walletPicker: some View {
        HStack(spacing: 0) {
            
            #if os(iOS)
            GraniteText("$")
            #else
            GraniteText("$")
                .frame(minWidth: 24)
            #endif
            
            PickerView(mutate: service.center.$state.binding.wallet.digit0,
                       digit: service.state.wallet.digit0,
                       width: ContainerConfig.iPhoneScreenWidth / 6 - 12,
                       options: service.state.wallet.options)

            
            PickerView(mutate: service.center.$state.binding.wallet.digit1,
                       digit: service.state.wallet.digit1,
                       width: ContainerConfig.iPhoneScreenWidth / 6 - 12,
                       options: service.state.wallet.options)

            
            PickerView(mutate: service.center.$state.binding.wallet.digit2,
                       digit: service.state.wallet.digit2,
                       width: ContainerConfig.iPhoneScreenWidth / 6 - 12,
                       options: service.state.wallet.options)

            
            GraniteText(",")
            
            PickerView(mutate: service.center.$state.binding.wallet.digit3,
                       digit: service.state.wallet.digit3,
                       width: ContainerConfig.iPhoneScreenWidth / 6 - 12,
                       options: service.state.wallet.options)

            PickerView(mutate: service.center.$state.binding.wallet.digit4,
                       digit: service.state.wallet.digit4,
                       width: ContainerConfig.iPhoneScreenWidth / 6 - 12,
                       options: service.state.wallet.options)

            
            PickerView(mutate: service.center.$state.binding.wallet.digit5,
                       digit: service.state.wallet.digit5,
                       width: ContainerConfig.iPhoneScreenWidth / 6 - 12,
                       options: service.state.wallet.options)

        }
    }
}

extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}
