//
//  File.swift
//  Domain
//
//  Created by Hosung.Kim on 2026.08.25.
//

import Foundation

extension Optional {
    public func unwrap(file: String = #fileID, line: Int = #line) throws -> Wrapped {
        guard let value = self else {
            throw UnwrapError.unexpectedNil(file: file, line: line)
        }
        return value
    }
}

public enum UnwrapError: Error, LocalizedError {
    case unexpectedNil(file: String, line: Int)
    
    public var errorDescription: String? {
        switch self {
        case .unexpectedNil(let file, let line):
            return "Unexpected nil at \(file):\(line)"
        }
    }
}
