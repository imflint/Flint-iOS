//
//  NetworkConfig.swift
//  FLINT
//
//  Created by 진소은 on 1/10/26.
//

import Foundation

public struct NetworkConfig {
    public let baseURL: URL
    public let defaultHeaders: [String: String]
    public let decoder: JSONDecoder

    public init(
        baseURL: URL,
        defaultHeaders: [String: String] = [:],
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.baseURL = baseURL
        self.defaultHeaders = defaultHeaders
        self.decoder = decoder
    }
}
