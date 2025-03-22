//
//  Logger.swift
//  Loom
//
//  Created by Ritesh Pakala Rao on 8/7/23.
//

import Foundation
public enum BullishLogLevel: Int32, CustomStringConvertible {
    case panic = 0
    case fatal = 8
    case error = 16
    case warning = 24
    case info = 32
    case verbose = 40
    case debug = 48
    case trace = 56

    public var description: String {
        switch self {
        case .panic:
            return "panic"
        case .fatal:
            return "fault"
        case .error:
            return "error"
        case .warning:
            return "warning"
        case .info:
            return "info"
        case .verbose:
            return "verbose"
        case .debug:
            return "debug"
        case .trace:
            return "trace"
        }
    }
}

extension BullishLogLevel {
    static var level: BullishLogLevel = .debug
}

@inline(__always) public func BullishLog(_ message: CustomStringConvertible,
                                       level: BullishLogLevel = .warning,
                                       file: String = #file,
                                       function: String = #function,
                                       line: Int = #line) {
    if level.rawValue <= BullishLogLevel.level.rawValue {
        let fileName = (file as NSString).lastPathComponent
        print("[Loom] | \(level) | \(fileName):\(line) \(function) | \(message)")
    }
}
