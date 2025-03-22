import Foundation
import SwiftUI
import Granite

final public class GraniteModalManager : ObservableObject, GraniteWindowDelegate, GraniteActionable {
    @GraniteAction<Void> var dismissPerfmored
    
    @Published var presenters = [AnyGraniteModal]()
    @Published var sheet : AnyView? = nil
    
    fileprivate var window : GraniteModalWindow? = nil
    public var view: AnyView? = nil

    public init(_ wrapper : @escaping ((GraniteModalContainerView) -> AnyView) = { view in AnyView(view) }) {
        #if os(iOS)
        DispatchQueue.main.async {
            self.attachWindow(wrapper)
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.didFinishLaunchingNotification, object: nil, queue: .main) { [weak self] _ in
            self?.attachWindow(wrapper)
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { [weak self] _ in
            self?.attachWindow(wrapper)
        }
        #else
        DispatchQueue.main.async {
            self.attachWindow(wrapper)
        }
        
        NotificationCenter.default.addObserver(forName: NSApplication.didFinishLaunchingNotification, object: nil, queue: .main) { [weak self] _ in
            self?.attachWindow(wrapper)
        }
        
        NotificationCenter.default.addObserver(forName: NSApplication.didBecomeActiveNotification, object: nil, queue: .main) { [weak self] _ in
            self?.attachWindow(wrapper)
        }
        #endif
    }
    
    public func present(_ modal : AnyGraniteModal) {
        
        #if os(iOS)
        withAnimation {
            presenters.append(modal)
        }
        window?.isUserInteractionEnabled = true
        #else
        presenters = [modal]
        #endif
    }
    
    public func dismiss() {
        guard presenters.count > 0 else {
            return
        }
        
        #if os(iOS)
        withAnimation {
            _ = presenters.removeLast()
            
            if presenters.count == 0 {
                
                window?.isUserInteractionEnabled = false
            }
        }
        #else
        _ = presenters.removeLast()
        dismissPerfmored.perform()
        #endif
        
    }
    
    public func didCloseWindow(_ id: String) {
        
    }
    
}

extension GraniteModalManager {
    
    fileprivate func attachWindow(_ wrapper : @escaping ((GraniteModalContainerView) -> AnyView)) {
        
        let rootView = wrapper(GraniteModalContainerView())
            .environmentObject(self)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(GraniteModalWindow.PassthroughView())
            .transformEnvironment(\.graniteAlertViewStyle) { value in
                value = .init()
            }
        
        #if os(iOS)
        guard window == nil else {
            return
        }
        
        guard let windowScene = UIApplication.shared
                .connectedScenes
                .first as? UIWindowScene else {
            return
        }
        
        let window = GraniteModalWindow(windowScene: windowScene)
        window.windowLevel = .alert
        window.rootViewController = UIHostingController(rootView: rootView)
        window.makeKeyAndVisible()
        window.isUserInteractionEnabled = false
        window.backgroundColor = UIColor.clear
        window.rootViewController?.view.backgroundColor = .clear
        
        self.window = window
        #else
        self.view = AnyView(rootView)
        #endif
    }
    
}
