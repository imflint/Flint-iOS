//
//  UserProfileEntity.swift
//  Domain
//
//  Created by 진소은 on 1/22/26.
//

import Foundation

public struct UserProfileEntity: Equatable {
    public let id: String
    public let nickname: String
    public let profileImageUrl: URL?
    public let role: UserRole

    public init(id: String, nickname: String, profileImageUrl: URL?, role: UserRole) {
        self.id = id
        self.nickname = nickname
        self.profileImageUrl = profileImageUrl
        self.role = role
    }
}
