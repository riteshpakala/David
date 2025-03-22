import Granite
import GraniteUI

import SwiftUI
import Foundation

extension Home: View {
    var safeAreaTop: CGFloat {
        #if os(iOS)
        return .layer1
        #else
        return 0
        #endif
    }
    
    var tabViewHeight: CGFloat {
        if Device.hasNotch {
            return 84
        } else {
            return 56
        }
    }
    
    var bottomPadding: CGFloat {
        if Device.hasNotch {
            return 24
        } else if Device.isMacOS {
            return 24
        } else if Device.isiPad {
            return 36
        } else {
            return 0
        }
    }
    
    var topPadding: CGFloat {
        if Device.isExpandedLayout {
            return 24
        } else {
            return 0
        }
    }
    
    var tabBarTopPadding: CGFloat {
        if Device.isMacOS {
            return 36
        } else if Device.isiPad {
            return 16
        } else {
            return 0
        }
    }
    
    var tabBarBottomPadding: CGFloat {
        if Device.isExpandedLayout {
            return 24
        } else {
            return 0
        }
    }

    
    public var view: some View {
        GraniteTabView(.init(height: tabViewHeight,
                             paddingIcons: .init(topPadding, 0, bottomPadding, 0),
                             landscape: Device.isExpandedLayout,
                             enableHaptic: true) {
            
            Brand.Colors.black.fitToContainer()
            
        }, currentTab: 0) {
            GraniteTab {
                Portfolio()
            } icon: {
                GraniteButton(.image("home_icon"),
                              selected: false,
                              size: .init(14),
                              padding: .init(0,
                                             Brand.Padding.small,
                                             Brand.Padding.xSmall,
                                             Brand.Padding.small))
            }
            
            GraniteTab {
                Floor()
            } icon: {
                GraniteButton(.image("floor_icon"),
                              selected: false,
                              size: .init(14),
                              padding: .init(0,
                                             Brand.Padding.small,
                                             Brand.Padding.xSmall,
                                             Brand.Padding.small))
            }
            
            GraniteTab {
                Playground()
            } icon: {
                GraniteButton(.imageSystem("testtube.2"),
                              selected: false,
                              size: .init(16),
                              padding: .init(0,
                                             Brand.Padding.small,
                                             Brand.Padding.xSmall,
                                             Brand.Padding.small))
            }
            
            GraniteTab {
                History()
            } icon: {
                GraniteButton(.imageSystem("hourglass"),
                              selected: false,
                              size: .init(16),
                              padding: .init(0,
                                             Brand.Padding.small,
                                             Brand.Padding.xSmall,
                                             Brand.Padding.small))
            }
            
            GraniteTab {
                Settings()
            } icon: {
                GraniteButton(.imageSystem("gearshape"),
                              selected: false,
                              size: .init(16),
                              padding: .init(0,
                                             Brand.Padding.small,
                                             Brand.Padding.xSmall,
                                             Brand.Padding.small))
            }
            
        }
        .edgesIgnoringSafeArea(edgesToEdgesToIgnore)
        .graniteNavigation(backgroundColor: Brand.Colors.black, disable: Device.isMacOS) {
            GraniteButton(.imageSystem("chevron.backward"),
                            selected: true,
                            size: .init(14),
                            padding: .init(0,
                                           Brand.Padding.small,
                                           Brand.Padding.xSmall,
                                           Brand.Padding.small))
        }
    }
    
    var edgesToEdgesToIgnore: Edge.Set {
        #if os(macOS)
        return []
        #else
        if Device.isExpandedLayout {
            return [.top, .bottom]
        } else {
            return [.bottom]
        }
        #endif
    }
}

