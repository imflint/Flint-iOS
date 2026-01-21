//
//  File.swift
//  Domain
//
//  Created by 김호성 on 2026.01.21.
//

import Foundation

public struct LoginEntity {
    public let accessToken: String
    public let refreshToken: String
    public let userId: String
    
    public init(accessToken: String, refreshToken: String, userId: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.userId = userId
    }
}
