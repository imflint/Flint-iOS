//
//  File.swift
//  Domain
//
//  Created by 김호성 on 2026.01.20.
//

import Foundation

public enum NetworkError: Error {
    case noData
    case decoding
    case httpStatusCode(code: Int, message: String)
    case unknown
}
