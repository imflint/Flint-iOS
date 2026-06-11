//
//  ConsoleLogger.swift
//  Log
//
//  Created by 김호성 on 2025.06.28.
//

import Foundation
import os

/// A lightweight logging utility that supports multiple output methods.
///
/// Each log message includes debugging information such as:
/// - Timestamp
/// - Log level
/// - Category
/// - Thread identifier
/// - Source file and line number
/// - Function name
///
/// ### Example output
/// ```text
/// 2026-06-11T06:21:15.782Z [DEBUG] [LifeCycle] [MainThread] [SplashViewController.swift:21] [init(viewModel:)]
/// SplashViewController init
/// ```
public struct ConsoleLogger: Sendable {
    private let logger: Logger
    private let category: String
    
    public init(category: String) {
        self.category = category
        logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.hosungkim.log", category: category)
    }
}

// MARK: - Public API
extension ConsoleLogger {
    
    /// Logs a debug message.
    /// - Note: These logs are only compiled and executed in DEBUG builds.
    public func d(_ objects: Any?..., separator: String = " ", method: OutputMethod = .oslog, filename: String = #fileID, line: Int = #line, funcName: StaticString = #function) {
        #if DEBUG
        log(objects, separator: separator, level: .debug, method: method, filename: filename, line: line, funcName: funcName)
        #endif
    }
    
    /// Logs an info message.
    public func i(_ objects: Any?..., separator: String = " ", method: OutputMethod = .oslog, filename: String = #fileID, line: Int = #line, funcName: StaticString = #function) {
        log(objects, separator: separator, level: .info, method: method, filename: filename, line: line, funcName: funcName)
    }
    
    /// Logs a notice message.
    public func n(_ objects: Any?..., separator: String = " ", method: OutputMethod = .oslog, filename: String = #fileID, line: Int = #line, funcName: StaticString = #function) {
        log(objects, separator: separator, level: .notice, method: method, filename: filename, line: line, funcName: funcName)
    }
    
    /// Logs an error message.
    public func e(_ objects: Any?..., separator: String = " ", method: OutputMethod = .oslog, filename: String = #fileID, line: Int = #line, funcName: StaticString = #function) {
        log(objects, separator: separator, level: .error, method: method, filename: filename, line: line, funcName: funcName)
    }
    
    /// Logs a fault message.
    public func f(_ objects: Any?..., separator: String = " ", method: OutputMethod = .oslog, filename: String = #fileID, line: Int = #line, funcName: StaticString = #function) {
        log(objects, separator: separator, level: .fault, method: method, filename: filename, line: line, funcName: funcName)
    }
}

// MARK: - Level
extension ConsoleLogger {
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
                return .`default`
            case .error:
                return .error
            case .fault:
                return .fault
            }
        }
    }
}

// MARK: - OutputMethod
extension ConsoleLogger {
    public enum OutputMethod {
        case oslog
        case nslog
        case print
    }
}

// MARK: - Logging
extension ConsoleLogger {
    private func log(_ objects: [Any?], separator: String, level: Level, method: OutputMethod, filename: String, line: Int, funcName: StaticString) {
        let content: String = objects.map({ "\($0 ?? "nil")" }).joined(separator: separator)
        
        let entry = Entry(
            time: Date(),
            level: level,
            category: category,
            thread: Thread.current.logIdentifier,
            filename: filename.lastFilePathComponent,
            line: line,
            funcName: funcName,
            content: content
        )
        
        switch method {
        case .oslog:
            logger.log(level: level.osLogType, "\(entry)")
        case .nslog:
            NSLog(entry.description)
        case .print:
            print(entry)
        }
    }
}

// MARK: - Entry
extension ConsoleLogger {
    
    /// A single log entry used to build a formatted log message.
    ///
    /// Example:
    /// 2026-06-11T06:21:15.782Z [DEBUG] [Main] [BaseViewController.swift:21] [init(viewControllerFactory:)]
    /// SplashViewController init
    private struct Entry: Sendable, CustomStringConvertible {
        let time: Date
        let level: Level
        let category: String
        let thread: String
        let filename: String
        let line: Int
        let funcName: StaticString
        let content: String
        
        var description: String {
            """
            \(time.formatted(Self.dateFormatStyle)) [\(level.rawValue)] [\(category)] [\(thread)] [\(filename):\(line)] [\(funcName)]
            \(content)
            """
        }
        
        private static let dateFormatStyle: Date.ISO8601FormatStyle = .iso8601
            .year()
            .month()
            .day()
            .dateSeparator(.dash)
            .timeZone(separator: .colon)
            .time(includingFractionalSeconds: true)
            .timeSeparator(.colon)
    }
}

// MARK: - Utility
extension Thread {
    fileprivate var logIdentifier: String {
        if isMainThread {
            return "MainThread"
        }
        // <NSThread: 0x600001709040>{number = 6, name = (null)}
        guard let threadNumber = description
            .split(separator: ",").first?
            .split(separator: "=").last?
            .trimmingCharacters(in: .whitespaces)
        else {
            return "BackgroundThread"
        }
        return "Thread\(threadNumber)"
    }
}

extension String {
    fileprivate var lastFilePathComponent: String {
        if #available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *) {
            return URL(filePath: self).lastPathComponent
        } else {
            return (self as NSString).lastPathComponent
        }
    }
}
