#if os(iOS)
import Foundation
import SwiftUI
 
struct AppBlurBackground : UIViewRepresentable {
    
    class IntensityVisualEffectView: UIVisualEffectView {
        
        var observer : NSObjectProtocol? = nil
        
        // MARK: Private
        var animator: UIViewPropertyAnimator!
        
        init(effect: UIVisualEffect, intensity: CGFloat) {
            super.init(effect: nil)
            animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [unowned self] in self.effect = effect }
            animator.fractionComplete = intensity
            
            observer = NotificationCenter.default.addObserver(forName: UIScene.didActivateNotification,
                                                              object: nil,
                                                              queue: .main) { [weak self] notification in
                self?.animator.stopAnimation(true)
                
                self?.animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [unowned self] in
                    self?.effect = effect
                }
                
                self?.animator.fractionComplete = intensity
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError()
        }
        
        deinit {
            if let observer = observer {
                NotificationCenter.default.removeObserver(observer)
            }
        }

    }
    
    let blurStyle : UIBlurEffect.Style
    let blurIntensity : CGFloat
    var whiteColorIntensity : CGFloat = 0.05

    func makeUIView(context: Context) -> IntensityVisualEffectView {
        let view = IntensityVisualEffectView(effect: UIBlurEffect(style: blurStyle),
                                             intensity: blurIntensity)
        
        let overlayView = UIView()
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.backgroundColor = .white.withAlphaComponent(whiteColorIntensity)
        view.contentView.addSubview(overlayView)
        
        overlayView.leftAnchor.constraint(equalTo: view.contentView.leftAnchor).isActive = true
        overlayView.topAnchor.constraint(equalTo: view.contentView.topAnchor).isActive = true
        overlayView.rightAnchor.constraint(equalTo: view.contentView.rightAnchor).isActive = true
        overlayView.bottomAnchor.constraint(equalTo: view.contentView.bottomAnchor).isActive = true
        
        return view
    }
    
    func updateUIView(_ uiView: IntensityVisualEffectView, context: Context) {
        if blurIntensity != uiView.animator.fractionComplete {
            uiView.animator.fractionComplete = blurIntensity
        }
    }
    
}

extension AppBlurBackground {
    
    static var tabBar : AppBlurBackground {
        .init(blurStyle: .systemThinMaterialLight,
              blurIntensity: 0.35)
    }
    
    static var banner : AppBlurBackground {
        .init(blurStyle: .systemThinMaterialLight,
              blurIntensity: 0.17)
    }
    
    static var modal : AppBlurBackground {
        .init(blurStyle: .systemThinMaterialLight,
              blurIntensity: 0.6,
              whiteColorIntensity: 0.0)
    }
    
    static var button : AppBlurBackground {
        .init(blurStyle: .systemThinMaterialLight,
              blurIntensity: 0.245)
    }
    
    static var toast : AppBlurBackground {
        .init(blurStyle: .systemThinMaterialLight,
              blurIntensity: 0.7)
    }
    
    static var alert : AppBlurBackground {
        .init(blurStyle: .systemThinMaterialLight,
              blurIntensity: 0.9,
              whiteColorIntensity: 0.0)
    }
    
}
#endif
