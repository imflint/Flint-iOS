//
//  File.swift
//  Data
//
//  Created by 김호성 on 2026.01.21.
//

import Foundation

public enum DTOMappingError: Error, LocalizedError {
    case missingField(String?)
    
    public var errorDescription: String? {
        switch self {
        case .missingField(let string):
            guard let string else {
                return "DTO Mapping Error: - missing field"
            }
            return "DTO Mapping Error: - missing field \(string)"
        }
    }
}

public func unwrap<T>(
    _ value: T?,
    key: CodingKey? = nil
) throws -> T {
    guard let value else {
        throw DTOMappingError.missingField(key?.stringValue)
    }
    return value
}
