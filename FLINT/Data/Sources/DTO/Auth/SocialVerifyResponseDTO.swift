//
//  File.swift
//  Data
//
//  Created by 김호성 on 2026.01.23.
//

import Foundation

import Entity

public struct SocialVerifyResponseDTO: Codable {
    public let isRegistered: Bool?
    public let accessToken: String?
    public let refreshToken: String?
    public let userId: String?
    public let nickname: String?
    public let tempToken: String?
    
    public init(isRegistered: Bool, accessToken: String?, refreshToken: String?, userId: String?, nickname: String?, tempToken: String?) {
        self.isRegistered = isRegistered
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.userId = userId
        self.nickname = nickname
        self.tempToken = tempToken
    }
}

extension SocialVerifyResponseDTO {
    public var entity: SocialVerifyResultEntity {
        get throws {
            return try SocialVerifyResultEntity(
                isRegistered: unwrap(isRegistered),
                userId: userId,
                nickname: nickname,
            )
        }
    }
}
