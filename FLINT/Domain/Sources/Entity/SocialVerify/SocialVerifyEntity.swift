//
//  File.swift
//  Domain
//
//  Created by 김호성 on 2026.01.23.
//

import Foundation

public struct SocialVerifyEntity {
    public let provider: SocialLoginType
    public let accessToken: String
    
    public init(provider: SocialLoginType, accessToken: String) {
        self.provider = provider
        self.accessToken = accessToken
    }
}
