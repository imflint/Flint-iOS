//
//  AppError.swift
//  FLINT
//
//  Created by 진소은 on 1/10/26.
//

import Foundation

public enum AppError: Error {
    case unauthorized
    case server(message: String)
    case network
    case decoding
    case unknown
}
