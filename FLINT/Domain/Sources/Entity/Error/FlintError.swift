//
//  File.swift
//  Domain
//
//  Created by 김호성 on 2026.05.08.
//

import Foundation

public enum FlintError: LocalizedError {
    case selfDeallocated
    case imageEncodingFailed
    
    public var errorDescription: String? {
        switch self {
        case .selfDeallocated:
            return "self is deallocated"
        case .imageEncodingFailed:
            return "image encoding failed"
        }
    }
}
