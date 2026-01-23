//
//  CollectionBookmarkUsersEntity.swift
//  Domain
//
//  Created by 진소은 on 1/23/26.
//

import Foundation

public struct CollectionBookmarkUsersEntity: Equatable {
    public let bookmarkCount: Int
    public let users: [CollectionBookmarkUserEntity]

    public init(bookmarkCount: Int, users: [CollectionBookmarkUserEntity]) {
        self.bookmarkCount = bookmarkCount
        self.users = users
    }
}

public struct CollectionBookmarkUserEntity: Equatable {
    public let userId: String
    public let nickname: String
    public let profileImageUrl: URL?
    public let userRole: String

    public init(userId: String, nickname: String, profileImageUrl: URL?, userRole: String) {
        self.userId = userId
        self.nickname = nickname
        self.profileImageUrl = profileImageUrl
        self.userRole = userRole
    }
}
