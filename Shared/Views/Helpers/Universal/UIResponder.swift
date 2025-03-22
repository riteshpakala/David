//
//  UIResponder.swift
//  Stoic
//
//  Created by Ritesh Pakala on 12/20/24.
//

import Foundation

#if os(macOS)

struct UIResponder {
    static var keyboardWillShowNotification: Notification.Name = .init("")
    static var keyboardWillHideNotification: Notification.Name = .init("")
}

#endif
