//
//  Log.swift
//  Domain
//
//  Created by Hosung.Kim on 2026.06.17 19:21.
//

import Foundation

import LogSystem

@LogSystem
public enum Log {
    
    public enum LoggerType: String {
        case network = "Network"
        case lifeCycle = "LifeCycle"
    }
    
    public static let subsystem = Bundle.main.bundleIdentifier ?? "com.imflint.flint"
}
