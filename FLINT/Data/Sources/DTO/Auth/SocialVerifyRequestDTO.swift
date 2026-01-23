//
//  File.swift
//  Data
//
//  Created by 김호성 on 2026.01.23.
//

import Foundation

import Entity

public struct SocialVerifyRequestDTO: Codable {
    public let provider: String
    public let accessToken: String
    
    public init(provider: String, accessToken: String) {
        self.provider = provider
        self.accessToken = accessToken
    }
}

extension SocialVerifyRequestDTO {
    public init(entity: SocialVerifyEntity) {
        provider = entity.provider.rawValue
        accessToken = entity.accessToken
    }
}
