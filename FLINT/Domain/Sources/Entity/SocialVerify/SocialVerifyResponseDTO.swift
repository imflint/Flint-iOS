//
//  File.swift
//  Data
//
//  Created by 김호성 on 2026.01.23.
//

import Foundation

public struct SocialVerifyResultEntity {
    public let isRegistered: Bool
    public let userId: String?
    public let nickname: String?
    
    public init(isRegistered: Bool, userId: String?, nickname: String?) {
        self.isRegistered = isRegistered
        self.userId = userId
        self.nickname = nickname
    }
}
