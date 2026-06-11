//
//  Log.swift
//  Domain
//
//  Created by Hosung.Kim on 2026.06.11 10:51.
//

import Foundation

public struct Log {
    
    private enum LoggerType: String {
        case main = "Main"
        case network = "Network"
        case lifeCycle = "LifeCycle"
    }
    
    private static let main = ConsoleLogger(category: LoggerType.main.rawValue)
    
    public static let network = ConsoleLogger(category: LoggerType.network.rawValue)
    public static let lifeCycle = ConsoleLogger(category: LoggerType.lifeCycle.rawValue)
    
    private init() {}
    
    public static func d(_ objects: Any?..., separator: String = " ", method: ConsoleLogger.OutputMethod = .oslog, filename: String = #fileID, line: Int = #line, funcName: StaticString = #function) {
        main.d(objects, separator: separator, method: method, filename: filename, line: line, funcName: funcName)
    }
    
    public static func i(_ objects: Any?..., separator: String = " ", method: ConsoleLogger.OutputMethod = .oslog, filename: String = #fileID, line: Int = #line, funcName: StaticString = #function) {
        main.i(objects, separator: separator, method: method, filename: filename, line: line, funcName: funcName)
    }
    
    public static func n(_ objects: Any?..., separator: String = " ", method: ConsoleLogger.OutputMethod = .oslog, filename: String = #fileID, line: Int = #line, funcName: StaticString = #function) {
        main.n(objects, separator: separator, method: method, filename: filename, line: line, funcName: funcName)
    }
    
    public static func e(_ objects: Any?..., separator: String = " ", method: ConsoleLogger.OutputMethod = .oslog, filename: String = #fileID, line: Int = #line, funcName: StaticString = #function) {
        main.e(objects, separator: separator, method: method, filename: filename, line: line, funcName: funcName)
    }
    
    public static func f(_ objects: Any?..., separator: String = " ", method: ConsoleLogger.OutputMethod = .oslog, filename: String = #fileID, line: Int = #line, funcName: StaticString = #function) {
        main.f(objects, separator: separator, method: method, filename: filename, line: line, funcName: funcName)
    }
}
