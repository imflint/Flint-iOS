//
//  File.swift
//  Domain
//
//  Created by 김호성 on 2026.01.23.
//

import Foundation

public struct SocialLoginEntity {
    public let accessToken: String
    public let refreshToken: String
    public let userId: String
    public let nickname: String
    
    public init(accessToken: String, refreshToken: String, userId: String, nickname: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.userId = userId
        self.nickname = nickname
    }
}
