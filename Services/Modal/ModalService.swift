import Foundation
import Granite
import SwiftUI
import GraniteUI
import SafariServices

struct ModalService : GraniteService {
    @Service var center: Center
    
    let modalManager = GraniteModalManager { view in
        AnyView(
            view
                .graniteAlertViewStyle(
                    GraniteAlertViewStyle(backgroundColor: Brand.Colors.black,
                                          foregroundColor: Color.white,
                                          actionColor: Brand.Colors.marbleV2,
                                          sheetVerticalPadding: 15)
                )
                .graniteToastViewStyle(
                    GraniteToastViewStyle(backgroundColor: Brand.Colors.black,
                                          foregroundColor: Color.white)
                )
        )
    }
    
    let sheetManager = GraniteSheetManager()
    
}

#if os(iOS)
extension UIApplication {
    
    var topViewController : UIViewController? {
        var topViewController: UIViewController? = nil
        if #available(iOS 13, *) {
            for scene in connectedScenes {
                if let windowScene = scene as? UIWindowScene {
                    for window in windowScene.windows {
                        guard window.isUserInteractionEnabled == true else {
                            continue
                        }
                        
                        if window.isKeyWindow {
                            topViewController = window.rootViewController
                        }
                    }
                }
            }
        } else {
            topViewController = keyWindow?.rootViewController
        }
        
        while true {
            if let presented = topViewController?.presentedViewController {
                topViewController = presented
            } else if let navController = topViewController as? UINavigationController {
                topViewController = navController.topViewController
            } else if let tabBarController = topViewController as? UITabBarController {
                topViewController = tabBarController.selectedViewController
            } else {
                // Handle any other third party container in `else if` if required
                break
            }
        }
        
        return topViewController
    }
    
}
#endif

extension ModalService {
    
    func dismissAll() {
        modalManager.dismiss()
        sheetManager.dismiss()
    }
    
}
