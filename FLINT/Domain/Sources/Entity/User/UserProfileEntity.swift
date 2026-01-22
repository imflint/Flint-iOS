//
//  UserProfileEntity.swift
//  Domain
//
//  Created by 진소은 on 1/22/26.
//

import Foundation

public struct UserProfileEntity {
    public let id: Int64
    public let nickname: String
    public let profileImageUrl: String
    public let isFliner: Bool

    public init(id: Int64, nickname: String, profileImageUrl: String, isFliner: Bool) {
        self.id = id
        self.nickname = nickname
        self.profileImageUrl = profileImageUrl
        self.isFliner = isFliner
    }
}
