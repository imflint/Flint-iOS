//
//  SocialVerifyEntity.swift
//  Domain
//
//  Created by 김호성 on 2026.01.23.
//

import Foundation

public struct SocialVerifyEntity {
    public let provider: SocialLoginType
    public let code: String?
    public let accessToken: String
    
    public init(provider: SocialLoginType, accessToken: String) {
        self.provider = provider
        self.code = nil
        self.accessToken = accessToken
    }
    
    public init(provider: SocialLoginType, code: String, accessToken: String) {
        self.provider = provider
        self.code = code
        self.accessToken = accessToken
    }
}
