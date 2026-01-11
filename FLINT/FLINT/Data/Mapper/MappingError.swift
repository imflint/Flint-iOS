//
//  MappingError.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.11.
//

import Foundation

enum MappingError: Error, LocalizedError {
    case server(code: Int, message: String)

    var errorDescription: String? {
        switch self {
        case let .server(code, message):
            return "Server error (code: \(code)): \(message)"
        }
    }
}
