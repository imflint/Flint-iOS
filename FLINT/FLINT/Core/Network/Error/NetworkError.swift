//
//  NetworkError.swift
//  FLINT
//
//  Created by 진소은 on 1/10/26.
//

import Foundation

public enum NetworkError: Error {
    case unauthorized
    case server(ServerError)
    case badRequest
    case timeout
    case networkFail
    case decoding
    case unknown
}

public struct ServerError: Decodable, Error {
    public let code: Int?
    public let message: String
}
