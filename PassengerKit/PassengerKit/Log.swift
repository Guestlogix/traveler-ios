//
//  Log.swift
//  Lib
//
//  Created by Lee, Sean on 2017-05-10.
//  Copyright © 2017 capco. All rights reserved.
//

import Foundation

@objc public enum LogLevel: Int {
    case error = 0
    case warning = 1
    case info = 2
    case debug = 3
    case trace = 4
    
    var initial: String {
        switch self {
        case .error:
            return "⛔️"
        case .warning:
            return "⚠️"
        case .info:
            return "I"
        case .debug:
            return "D"
        case .trace:
            return "T"
        }
    }
}

public var logLevel: LogLevel = .trace

public func Log(_ message: @autoclosure () -> String, data: Any? = nil, level: LogLevel = .debug, filename: String = #file, function: String = #function, line: Int = #line) {
    
    let file = "\((filename as NSString).lastPathComponent)"
    
    let fileInfo = (logLevel.rawValue >= 4) ? ("[\(level.initial)] - [\(file).\(function) - Line \(line)]") : ("[\(level.initial)] - [\(file)]")
    
    if (logLevel.rawValue >= level.rawValue) {
        var logMessage = "\(fileInfo) => \(message())"
        if let data = data {
            logMessage = "\(logMessage)\n    - \(data)"
        }
        
        print(logMessage)
    }
}
