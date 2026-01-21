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
    case httpStatusCode(ServerError)
    case unknown
}

public struct ServerError: Sendable {
    public let title: String
    public let detail: String
    public let instance: String
    public let errorCode: String
    public let additionalInfo: [String: String]
    
    public let status: Int
    public let message: String
    
    public init(title: String, detail: String, instance: String, errorCode: String, additionalInfo: [String : String], status: Int, message: String) {
        self.title = title
        self.detail = detail
        self.instance = instance
        self.errorCode = errorCode
        self.additionalInfo = additionalInfo
        self.status = status
        self.message = message
    }
}
