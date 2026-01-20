//
//  Log.swift
//  Flint
//
//  Created by 김호성 on 2025.06.28.
//

import Foundation
import os

/// Centralized Custom Logging System
public struct Log {
    
    private static let enabled: Bool = true
    
    private static let subsystem: String = Bundle.main.bundleIdentifier ?? "com.flint.flint"
    private static let logger: Logger = Logger(subsystem: subsystem, category: "Log")
    
    private static let dateFormatter: DateFormatter = {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return dateFormatter
    }()
    
    private init() { }
    
    /// Logs a debug message.
    /// - Note: These logs are only compiled and executed in DEBUG builds.
    public static func d(_ objects: Any?..., separator: String = " ", method: OutputMethod = .oslog, filename: String = #file, line: Int = #line, funcName: String = #function) {
        #if DEBUG
        log(objects, separator: separator, level: .debug, method: method, filename: filename, line: line, funcName: funcName)
        #endif
    }
    
    /// Logs an info message.
    public static func i(_ objects: Any?..., separator: String = " ", method: OutputMethod = .oslog, filename: String = #file, line: Int = #line, funcName: String = #function) {
        log(objects, separator: separator, level: .info, method: method, filename: filename, line: line, funcName: funcName)
    }
    
    /// Logs a notice message.
    public static func n(_ objects: Any?..., separator: String = " ", method: OutputMethod = .oslog, filename: String = #file, line: Int = #line, funcName: String = #function) {
        log(objects, separator: separator, level: .notice, method: method, filename: filename, line: line, funcName: funcName)
    }
    
    /// Logs an error message.
    public static func e(_ objects: Any?..., separator: String = " ", method: OutputMethod = .oslog, filename: String = #file, line: Int = #line, funcName: String = #function) {
        log(objects, separator: separator, level: .error, method: method, filename: filename, line: line, funcName: funcName)
    }
    
    /// Logs a fault message.
    public static func f(_ objects: Any?..., separator: String = " ", method: OutputMethod = .oslog, filename: String = #file, line: Int = #line, funcName: String = #function) {
        log(objects, separator: separator, level: .fault, method: method, filename: filename, line: line, funcName: funcName)
    }
    
    private static func log(_ objects: [Any?], separator: String, level: Level, method: OutputMethod, filename: String, line: Int, funcName: String) {
        guard enabled else { return }
        let objectsMessage: String = objects.map({ "\($0 ?? "nil")" }).joined(separator: separator)
        let message: String = "\(dateFormatter.string(from: Date())) [\(level.rawValue)] [\(getThreadName())] [\(getFileName(filename)):\(line)] \(funcName) : \(objectsMessage)"
        switch method {
        case .oslog:
            logger.log(level: level.osLogType, "\(message)")
        case .nslog:
            NSLog(message)
        case .print:
            print(message)
        case .custom(let closure):
            closure(objects)
        }
    }
    
    public enum OutputMethod {
        public typealias Closure = (_ objects: Any?...) -> Void
        
        case oslog
        case nslog
        case print
        case custom(Closure)
    }
    
    private enum Level: String {
        case debug  = "DEBUG"
        case info   = "INFO"
        case notice = "NOTICE"
        case error  = "ERROR"
        case fault  = "FAULT"
        
        var osLogType: OSLogType {
            switch self {
            case .debug:
                return .debug
            case .info:
                return .info
            case .notice:
                return .default
            case .error:
                return .error
            case .fault:
                return .fault
            }
        }
    }
    
    private static func getFileName(_ file: String) -> String {
        return file.components(separatedBy: "/").last ?? file
    }
    
    private static func getThreadName() -> String {
        if Thread.current.isMainThread {
            return "Main"
        } else {
            // <NSThread: 0x600001709040>{number = 6, name = (null)}
            let threadNumber = Thread.current.description.split(separator: ",").first!.split(separator: "=").last!.trimmingCharacters(in: .whitespaces)
            return "\(threadNumber)"
        }
    }
}
