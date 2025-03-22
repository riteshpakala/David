//
//  OrderView.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/3/23.
//

import Foundation
import SwiftUI
import Granite
import GraniteUI

struct OrderView: View {
    @GraniteAction<HoldingsService.Center.Order.Meta> var placeOrder
    
    var lastStock: Stock
    @State var currentHoldings: Double
    @State var currentlyOwned: Double
    var isSell: Bool = false
    
    @State var order: Order = .init()
    
    var orderPriceDisplay: String {
        return order.priceDisplay(for: lastStock)
    }
    
    var currentOrderPrice: Double {
        if isSell {
            return currentHoldings + order.price(for: lastStock)
            
        } else {
            return currentHoldings - order.price(for: lastStock)
        }
    }
    
    var currentOrderPriceDisplayString: String {
        //TODO: make this formatting process reusable
        var formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter.string(from: currentOrderPrice as NSNumber) ?? ""
    }
    
    @State var errorMessage: String? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                
                PickerView(mutate: $order.digit0,
                           digit: order.digit0,
                           width: ContainerConfig.iPhoneScreenWidth / 6 - 12,
                           options: order.options)

                
                PickerView(mutate: $order.digit1,
                           digit: order.digit1,
                           width: ContainerConfig.iPhoneScreenWidth / 6 - 12,
                           options: order.options)

                
                PickerView(mutate: $order.digit2,
                           digit: order.digit2,
                           width: ContainerConfig.iPhoneScreenWidth / 6 - 12,
                           options: order.options)
                
                VStack {
                    
                    GraniteText(.init("Cost: " + orderPriceDisplay),
                                Brand.Colors.green,
                                .subheadline,
                                .bold,
                                .trailing)
                            .padding(.bottom, 2)
                    
                    GraniteText(.init("Owned: " + currentlyOwned.display),
                                .caption,
                                .regular,
                                .trailing)
                    
                    GraniteText(.init("Wallet: " + currentOrderPriceDisplayString),
                                .caption,
                                .regular,
                                .trailing)
                    
                }.padding(.trailing, Brand.Padding.xSmall)
            }
            
            Button(action: {
                GraniteHaptic.light.invoke()
                
                let invoice: HoldingsService.Center.Order.Meta = .init(stock: lastStock,
                                                                     amount: order.joinedPure,
                                                                     newValue: currentOrderPrice)
                if isSell,
                   currentlyOwned - order.joinedPure >= 0 {
                    currentlyOwned -= order.joinedPure
                    currentHoldings += order.price(for: lastStock)
                    
                    placeOrder.perform(invoice)
                } else if isSell {
                    errorMessage = "Can't sell more than you own."
                }
                
                if isSell == false,
                   currentHoldings >= order.price(for: lastStock) {
                    currentlyOwned += order.joinedPure
                    currentHoldings -= order.price(for: lastStock)
                    
                    placeOrder.perform(invoice)
                } else if isSell == false {
                    errorMessage = "Can't buy more than you can afford."
                }
            }) {
                GraniteButton(isSell ? "sell" : "purchase")
            }
            .buttonStyle(PlainButtonStyle())
            
            if let error = self.errorMessage {
                GraniteText(.init(error),
                            Brand.Colors.redBurn)
            }
        }
    }
    
    struct Order: GraniteModel {
        
        var digit0: Int = 0
        var digit1: Int = 0
        var digit2: Int = 1
        
        var options: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        
        var joinedPure: Double {
            Double(Int("\(digit0)\(digit1)\(digit2)") ?? 0)
        }
        
        func price(for security: Security) -> Double {
            return Double(security.lastValue * joinedPure)
        }
        
        func priceDisplay(for security: Security) -> String {
            var formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = 2
            return .init(formatter.string(from: price(for: security) as NSNumber) ?? "")
        }
    }
}
