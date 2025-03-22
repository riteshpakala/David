import Foundation
import GraniteUI
import SwiftUI
import SafariServices

extension ModalService {
    
    #if os(iOS)
    func present(_ modal : AnyGraniteModal) {
        modalManager.present(modal)
    }
    #else
    func present(id: String = GraniteSheetManager.defaultId,
                 _ alert: GraniteAlertView) {
        presentSheet(id: id) {
            alert
                .attach( {
                    sheetManager.dismiss(id: id)
                }, at: \.dismiss)
                .frame(maxWidth: 480)
                .environmentObject(modalManager)
        }
    }
    #endif
    
    func presentErrorToast(title: LocalizedStringKey = "Error", error: Error?) {
        #if os(iOS)
        modalManager.present(GraniteToastView(title: title,
                                              message: .init(error?.localizedDescription ?? "Something went wrong"),
                                              event: .error))
        #endif
    }
    
    func dismiss() {
        modalManager.dismiss()
    }
    
}

extension ModalService {
    
    var shouldPreventSheetDismissal : Bool {
        get {
            sheetManager.shouldPreventDismissal
        }
        nonmutating set {
            sheetManager.shouldPreventDismissal = newValue
        }
    }
    
    func presentSheet<Content : View>(id: String = GraniteSheetManager.defaultId,
                                      style : GraniteSheetPresentationStyle = .sheet, @ViewBuilder content : () -> Content) {
        sheetManager.present(id: id, content: content, style: style)
    }
    
    func dismissSheet() {
        sheetManager.dismiss()
    }
    
}

extension ModalService {
    
    func presentActivitySheet(items : [Any]) {
        #if os(iOS)
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        controller.overrideUserInterfaceStyle = .dark
        
        let parentController = UIApplication.shared.topViewController ?? UIApplication.shared.windows.first?.rootViewController
        parentController?.present(controller, animated: true, completion: nil)
        #endif
    }
    
    func presentBrowser(url : URL) {
        #if os(iOS)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        if components?.scheme == nil {
            components?.scheme = "http"
        }
        
        guard let url = components?.url else {
            return
        }
        
        let controller = SFSafariViewController(url: url)
        controller.overrideUserInterfaceStyle = .dark
        controller.modalPresentationStyle = .overFullScreen
        
        let parentController = UIApplication.shared.topViewController ?? UIApplication.shared.windows.first?.rootViewController
        parentController?.present(controller, animated: true, completion: nil)
        #endif
    }
    
}
