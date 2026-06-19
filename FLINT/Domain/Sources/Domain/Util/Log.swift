//
//  Log.swift
//  Domain
//
//  Created by Hosung.Kim on 2026.06.17 19:21.
//

import Foundation

@_exported import ConsoleLog

public enum Log {
    
    @ConsoleLoggerCategory
    private enum Category: String {
        case network = "Network"
        case lifeCycle = "LifeCycle"
    }
}
