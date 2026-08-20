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
    /// GET /users/me 에만 포함. 다른 유저 조회 시 nil.
    public let keywordRecalculatable: Bool?

    public init(
        id: String,
        nickname: String,
        profileImageUrl: URL?,
        role: UserRole,
        keywordRecalculatable: Bool? = nil
    ) {
        self.id = id
        self.nickname = nickname
        self.profileImageUrl = profileImageUrl
        self.role = role
        self.keywordRecalculatable = keywordRecalculatable
    }
}
