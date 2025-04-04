//
//  MovingNumbersView.swift
//  MovingNumbersView
//
//  Created by Wirawit Rueopas on 4/12/20.
//  Copyright © 2020 Wirawit Rueopas. All rights reserved.
//

import SwiftUI

struct MovingNumbersView<Element: View>: View {
    /// The number to show.
    let number: Double
    
    /// Number of decimal places to show. If 0, will show integers (i.e. no dot or decimal)
    ///
    /// Note that we round up  before showing.
    let numberOfDecimalPlaces: Int
    
    /// Space between each digit in the 10-digit vertical stack
    var verticalDigitSpacing: CGFloat = 0
    
    var animationDuration: Double = 0.25
    
    /// Give a fixed width to the view. This would give better transition effect as digits are not clipped off.
    var fixedWidth: CGFloat? = nil
    
    var alignment: Alignment
    
    /// Function to build digit, comma, and dot components
    let elementBuilder: (String) -> Element
    
    var digitStackAnimation: Animation {
        Animation
            .easeOut(duration: animationDuration)
    }
    
    var elementTransition: AnyTransition {
        AnyTransition.move(edge: .leading)
    }
    
    func getWholeVisualElements(whole: Int) -> [VisualElementType] {
        let wholeDigits = getAllDigitsInAscendingSignificance(number: whole)
        var wholeElements: [VisualElementType] = []
        
        for (i, digit) in wholeDigits.enumerated() {
            if i != 0 && i % 3 == 0 {
                wholeElements.append(.comma(position: i+1))
            }
            wholeElements.append(.digit(digit, position: i+1))
        }
        return wholeElements
    }
    
    func getFractionVisualElements(fraction: Double, numberOfDecimalPlaces: Int) -> [VisualElementType] {
        var fractionElements: [VisualElementType] = []
        let decimals = Int(round(fraction * pow(10.0, Double(numberOfDecimalPlaces))))
        // [5, 4]
        var fractionDigits = getAllDigitsInAscendingSignificance(number: decimals)
        // Prepend with 0s that're gone when fraction is 0.
        let numberOfAdditionalZeros = numberOfDecimalPlaces - fractionDigits.count
        if numberOfAdditionalZeros > 0 {
            fractionDigits.append(contentsOf: repeatElement(0, count: numberOfAdditionalZeros))
        }
        
        // Work from least significant: [4, 5]
        for (i, digit) in fractionDigits.reversed().enumerated() {
            fractionElements.append(.decimalDigit(digit, position: i+1))
        }
        
        return fractionElements
    }
    
    func movingNumbersPlate() -> some View {
        let isNegative = self.number < 0
        
        // Deal with positive first
        let number = abs(self.number)
        
        // Rounding
        let roundedNumber = round(number, numPlaces: numberOfDecimalPlaces)
        
        // Split
        let (whole, fraction) = modf(roundedNumber)
        
        // Example: 123.45
        
        // Whole - 123
        let wholeElements = getWholeVisualElements(whole: Int(whole.isNaN ? 0 : whole)) // [3,2,1]
        
        let negativeElement: [VisualElementType] = isNegative ? [.minus] : []
        let allElements: [VisualElementType]
        
        // Fraction
        if numberOfDecimalPlaces > 0 {
            // [4, 5]
            let fractionElements = getFractionVisualElements(fraction: fraction, numberOfDecimalPlaces: numberOfDecimalPlaces)
            allElements = negativeElement + wholeElements.reversed() + [.dot] + fractionElements
        } else {
            allElements = negativeElement + wholeElements.reversed()
        }
        
        // All elements are centered (digit stack, comma, dot)
        let finalResultView = HStack(alignment: .center, spacing: 1) {
            if alignment == .center {
                Spacer()
            }
            ForEach(allElements) { (element) in
                self.viewFromElement(element)
                    .transition(self.elementTransition)
                    .animation(self.digitStackAnimation)
                    .background(Brand.Colors.black.opacity(0.75))
            }
            if alignment == .center {
                Spacer()
            }
        }
        .frame(width: fixedWidth, alignment: .leading)
        
        // PROBLEM: Final result view takes a big size
        // (i.e. 10-digit stack height, no. of digits width)
        // We want the final layout of the view to be just like
        // its appearance, i.e. A couple of Texts in HStack.
        
        // HACK: Make a stand-in estimated view for layout.
        // So this allows us to treat this view almost like Text
        //
        // TODO: Is there a better way to calculate layout correctly?
        // Would `PreferenceKey` works?
        let estimatedView = HStack(spacing: 0) {
            ForEach(allElements) { el -> Element in
                switch el {
                case .minus:
                    return self.elementBuilder("-")
                case .dot:
                    return self.elementBuilder(".")
                case .comma:
                    return self.elementBuilder(",")
                case .digit, .decimalDigit:
                    // This column takes the widest one.
                    // We estimate it to be 9.
                    return self.elementBuilder("9")
                }
            }
        }
        .frame(width: fixedWidth)
        
        return estimatedView
            .opacity(0.0)
            .overlay(
                finalResultView,
                alignment: .leading)
            .mask(Rectangle())
    }
    
    var body: some View {
        movingNumbersPlate()
    }
}

/// Given an **non-negative** integer, extract all digits starting *from least to most significant position*, i.e. 123 -> [3,2,1]
///
/// Note that if `number` is negative, we use `abs(number)`.
func getAllDigitsInAscendingSignificance(number: Int) -> [Int] {
    if number == 0 {
        return [0]
    }
    var rest = abs(number)
    var digits: [Int] = []
    while rest >= 10 {
        let quotient = rest / 10
        let d = rest - (quotient * 10)
        digits.append(d)
        rest = quotient
    }
    if rest != 0 {
        digits.append(rest)
    }
    return digits
}

extension MovingNumbersView {
    enum VisualElementType: CustomDebugStringConvertible, Identifiable {
        case digit(Int, position: Int)
        case comma(position: Int)
        case dot
        case decimalDigit(Int, position: Int)
        case minus
        
        var id: Int {
            // - Digit has id as a multiple of 10s,
            // - Decimal place has a negative multiple of 10s
            // - 0 is reserved for dot.
            // - 1 is reserved for minus
            // - comma is the id of previous digit + 5.
            //
            // I.e. -1,234.56 -> [1(minus), 40, 35, 30, 20, 10, 0(dot), -10, -20]
            switch self {
            case let .digit(_, position):
                assert(position > 0)
                return 10 * position
            case let .comma(position):
                assert(position > 0)
                // Give comma the id between two digits.
                return 10 * position + 5
            case let .decimalDigit(_, position):
                assert(position > 0)
                return -10 * position
            case .dot:
                // Reserve 0 for dot
                return 0
            case .minus:
                // Reserve of "-"
                return 1
            }
        }
        var debugDescription: String {
            switch self {
            case .dot: return "."
            case let .comma(p): return ",(pos:\(p))"
            case let .digit(val, p): return "\(val)(pos:\(p))"
            case let .decimalDigit(val, p): return "\(val)(pos:\(p))"
            case .minus: return "-"
            }
        }
    }
    
    func viewFromElement(_ element: VisualElementType) -> some View {
        switch element {
        case let .digit(value, _):
            return AnyView(self.buildDigitStack(showingDigit: value))
        case let .decimalDigit(value, _):
            return AnyView(self.buildDigitStack(showingDigit: value))
        case .dot:
            return AnyView(self.buildDot())
        case .comma:
            return AnyView(self.buildComma())
        case .minus:
            return AnyView(self.buildMinus())
        }
    }
    
    func buildDigitStack(showingDigit digit: Int) -> some View {
        let digit = CGFloat(digit)
        let ds = TenDigitStack(
            spacing: verticalDigitSpacing,
            elementBuilder: elementBuilder)
            .modifier(VerticalShift(
                diffNumber: digit,
                digitSpacing: verticalDigitSpacing))
        return ds
    }
    
    func buildComma() -> some View {
        elementBuilder(",")
    }
    
    func buildDot() -> some View {
        elementBuilder(".")
    }
    
    func buildMinus() -> some View {
        elementBuilder("-")
    }
    
    /// A vertical stack of 9 -> 0.
    struct TenDigitStack: View {
        var spacing: CGFloat? = nil
        let elementBuilder: (String) -> Element
        var body: some View {
            VStack(alignment: .center, spacing: spacing) {
                ForEach((0...9).reversed(), id: \.self) { iDigit in
                    self.elementBuilder("\(iDigit)")
                }
            }
            .padding(.bottom, spacing)
            // Padding so the bottom most digit (0)
            // has the padding like others.
        }
    }
    
    struct VerticalShift: GeometryEffect {
        var diffNumber: CGFloat
        let digitSpacing: CGFloat
        
        var animatableData: CGFloat {
            get { diffNumber }
            set { diffNumber = newValue }
        }
        
        func effectValue(size: CGSize) -> ProjectionTransform {
            // The 0.5 is to center right at a single number.
            // i.e. for 10 digits the center is between some two numbers.
            let translationY = -size.height/2 + (size.height / 10) * (diffNumber + 0.5) + digitSpacing/2
            return .init(.init(
                translationX: 0,
                y: translationY
            ))
        }
    }
}

func round(_ number: Double, numPlaces: Int) -> Double {
    let power = pow(10.0, Double(numPlaces))
    return round(number * power)/power
}
