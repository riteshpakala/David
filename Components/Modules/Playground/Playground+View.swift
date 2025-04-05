import Granite
import SwiftUI
import GraniteUI
import DavidKit

extension Playground: View {
    var columns: [GridItem] {
        [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    }
    
    var columns2: [GridItem] {
        [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    }
    
    func outputSelected(_ output: StockServiceModels.Indicators.Context) -> Bool {
        return state.selectedOutput == output
    }
    
    func backgroundColorForOutput(_ output: StockServiceModels.Indicators.Context) -> Color {
        return outputSelected(output) ? Brand.Colors.yellow : Brand.Colors.black
    }
    
    func indicatorIsSelected(_ indicator: StockServiceModels.Indicators.Variant) -> Bool {
        return state.selectedIndicators.contains(indicator)
    }
    
    func backgroundColorForIndicator(_ indicator: StockServiceModels.Indicators.Variant) -> Color {
        return indicatorIsSelected(indicator) ? Brand.Colors.yellow : Brand.Colors.black
    }
    
    func rangeIsSelected(_ index: TonalRange) -> Bool {
        return state.selectedTonalRange == index
    }
    
    func backgroundColorForRange(_ index: TonalRange) -> Color {
        return rangeIsSelected(index) ? Brand.Colors.yellow : Brand.Colors.black
    }
    
    public var view: some View {
        ZStack {
            //Loading
            GeometryReader { proxy in
                GradientView(colors: [Brand.Colors.redBurn,
                                      Brand.Colors.marble],
                             cornerRadius: 0.0,
                             direction: .top)
                .shadow(color: Color.black,
                        radius: 8.0,
                        x: 4.0,
                        y: 3.0)
                .ignoresSafeArea()
                .offset(x: 0,
                        y: ((proxy.size.height)*(1.0 - (state.trainingProgress.isNaN ? 0.0 : state.trainingProgress))) + (state.trainingProgress == .zero ? 8 : 0)
                )
                .animation(.default, value: state.trainingProgress)
            }
            
            VStack {
                HStack {
                    GraniteText(state.currentStep == .predict ? "\(state.stock?.display ?? "")" : "forecast",
                                .headline)
                    .padding(.leading, state.currentStep == .predict ? 0 : Brand.Padding.medium)
                    
                    
                    if state.currentStep != .predict {
                        Spacer()
                    }
                }.padding(.top, Brand.Padding.medium)
                
                //                if let stock = state.stock {
                //                    Spacer().frame(height: 36)
                //                        .padding(Brand.Padding.medium)
                //
                //                    AssetDetail(.preview, stock: stock)
                //                }
                VStack(spacing: 0) {
                    switch state.currentStep {
                    case .search, .tune:
                        rangeSelector
                            .padding(.top, Brand.Padding.medium)
                    default:
                        EmptyView()
                    }
                    
                    switch state.currentStep {
                    case .generate, .training:
                        indicatorSelector
                            .padding(.top, Brand.Padding.medium)
                        indicatorOutputView
                            .padding(.top, Brand.Padding.xMedium)
                    case .predict:
                        predictView
                            .padding(.top, Brand.Padding.medium)
                            .onAppear {
                                //center.predict.send()
                            }
                    default:
                        EmptyView()
                    }
                    
                    Spacer()
                    
                    switch state.currentStep {
                    case .tune:
                        Button(action: {
                            GraniteHaptic.light.invoke()
                            center.prepareToTrain.send()
                        }) {
                            GraniteButton("next", padding: .init(Brand.Padding.medium, 0))
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.top, 4)
                    case .generate:
                        HStack {
                            Button(action: {
                                center.$state.binding.currentStep.wrappedValue = .tune
                            }) {
                                GraniteButton("back", padding: .init(Brand.Padding.medium, 0))
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Spacer()
                            
                            Button(action: {
                                GraniteHaptic.light.invoke()
                                center.$state.binding.currentStep.wrappedValue = .training
                                center.train.send()
                            }) {
                                GraniteButton("train",
                                              textColor: Brand.Colors.white,
                                              colors: [Brand.Colors.yellow, Brand.Colors.redBurn.opacity(0.42)],
                                              padding: .init(Brand.Padding.medium, 0))
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.trailing, state.model != nil ? 0 : 8)
                            
                            if state.model != nil {
                                
                                Button(action: {
                                    GraniteHaptic.light.invoke()
                                    center.$state.binding.currentStep.wrappedValue = .predict
                                }) {
                                    GraniteButton(.imageSystem("arrow.right.square"),
                                                  selected: true,
                                                  size: .init(16),
                                                  padding: .init(0,
                                                                 0,
                                                                 0,
                                                                 0))
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.trailing, 8 + Brand.Padding.medium)
                            }
                        }
                        .padding(.top, 4)
                    case .training:
                        //TODO: LOL
                        HStack {
                            Button(action: {
                                center.$state.binding.currentStep.wrappedValue = .tune
                            }) {
                                GraniteButton("back", padding: .init(Brand.Padding.medium, 0))
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Spacer()
                            
                            Button(action: {
                                center.$state.binding.currentStep.wrappedValue = .training
                                center.train.send()
                            }) {
                                GraniteButton("train",
                                              textColor: Brand.Colors.white,
                                              colors: [Brand.Colors.yellow, Brand.Colors.redBurn.opacity(0.42)],
                                              padding: .init(Brand.Padding.medium, 0))
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.trailing, 8)
                        }
                        .padding(.top, 4)
                        .opacity(0.3)
                    case .predict:
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                center.$state.binding.currentStep.wrappedValue = .generate
                            }) {
                                GraniteButton("back", padding: .init(Brand.Padding.medium, 0))
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Spacer()
                        }
                        .padding(.top, 4)
                    default:
                        EmptyView()
                    }
                    
                }
                .padding(.top, (state.currentStep == .generate || state.currentStep == .training || state.currentStep == .predict) ? 0 : Brand.Padding.large * 2)
                .overlayIf(state.tonalRanges.isEmpty) {
                    if state.currentStep == .tune {
                        ZStack {
                            Brand.Colors.black.opacity(0.75)
                                .ignoresSafeArea()
                                .offset(y: 8)
                            
                            ProgressView()
                                .scaleEffect(1.2)
                                .padding(.top, 8)
                                .padding(.bottom, 12)
                        }
                    } else {
                        
                        GraniteDisclaimerView("The \"Generative Forecast\" model is created here. Search for a Stock for a possible % change prediction of the next trading day.")
                            .padding(.top, state.currentStep == .generate ? 0 : ((Brand.Padding.large * 2) - 8))
                            .offset(y: 8)
                    }
                }
                
                Spacer()
            }
            
            if state.currentStep == .search || state.currentStep == .tune {
                AssetSearch(shouldRoute: false)
                    .attach(center.assetSelected, at: \.assetSelected)
                    .padding(.top, Brand.Padding.large + 8)
            }
            
            if state.currentStep == .training /*|| (state.currentStep == .predict && state.predictionState == .predicting)*/ {
                Brand.Colors.black.opacity(0.75)
                    .ignoresSafeArea()
                    .offset(y: 8)
                VStack {
                    Spacer()
                    
                    if state.currentStep == .training {
                        GraniteText("Training with a\ntonality of\n\(state.days) days",
                                    .headline)
                        .padding(.horizontal, 12)
                        
                        Brand.Colors.yellow.overlay(
                            GraniteText(.init(state.selectedTonalRange?.dateInfoShortDisplay ?? ""),
                                        Brand.Colors.black,
                                        .subheadline,
                                        .regular)
                        )
                        .frame(width: 116,
                               height: 85)
                        .cornerRadius(8)
                        .shadow(color: .black, radius: 2, x: 2, y: 2)
                    }
                    
                    if state.currentStep == .training {
                        GraniteText("\(Double(state.trainingProgress).percentRounded)%",
                                    .title3,
                                    .bold)
                        .frame(width: 100,
                               height: 60)
                        .applyGradient(selected: true,
                                       colors: [Brand.Colors.marbleV2.opacity(0.66),
                                                Brand.Colors.marble])
                        .padding(.top, Brand.Padding.medium)
                        
                        
                        ProgressView()
                            .scaleEffect(1.2)
                            .padding(.top, 12)
                            .padding(.bottom, 12)
                        
                        Spacer()
                        
                        Button(center.trainCancel) {
                            GraniteButton("cancel",
                                          textColor: Brand.Colors.white,
                                          colors: [Brand.Colors.redBurn, Brand.Colors.red.opacity(0.42)],
                                          padding: .init(Brand.Padding.medium, 0))
                        }
                        .buttonStyle(PlainButtonStyle())
                    } else {
                        ProgressView()
                            .scaleEffect(1.2)
                            .padding(.top, 8)
                            .padding(.bottom, 12)
                    }
                    
                    
                    Spacer()
                }
            }
        }
        .padding(.bottom, .layer1)
    }
}

public struct HalfCapsule: View, InsettableShape {
    private let inset: CGFloat
    
    public func inset(by amount: CGFloat) -> HalfCapsule {
        HalfCapsule(inset: self.inset + amount)
    }
    
    public func path(in rect: CGRect) -> Path {
        let width = rect.size.width - inset * 2
        let height = rect.size.height - inset * 2
        let heightRadius = height / 2
        let widthRadius = width / 2
        let minRadius = min(heightRadius, widthRadius)
        return Path { path in
            path.move(to: CGPoint(x: width, y: 0))
            path.addArc(center: CGPoint(x: minRadius, y: minRadius), radius: minRadius, startAngle: Angle(degrees: 270), endAngle: Angle(degrees: 180), clockwise: true)
            path.addArc(center: CGPoint(x: minRadius, y: height - minRadius), radius: minRadius, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 90), clockwise: true)
            path.addLine(to: CGPoint(x: width, y: height))
            path.closeSubpath()
        }.offsetBy(dx: inset, dy: inset)
    }
    
    public var body: some View {
        GeometryReader { geometry in
            self.path(in: CGRect(x: 0, y: 0, width: geometry.size.width, height: geometry.size.height))
        }
    }
    
    public init(inset: CGFloat = 0) {
        self.inset = inset
    }
}
