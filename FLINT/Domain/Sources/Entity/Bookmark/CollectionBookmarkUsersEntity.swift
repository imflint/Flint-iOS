//
//  CollectionBookmarkUsersEntity.swift
//  Domain
//
//  Created by 진소은 on 1/23/26.
//

import Foundation

public struct CollectionBookmarkUsersEntity: Equatable {
    public let bookmarkCount: Int
    public let users: [UserProfileEntity]

    public init(bookmarkCount: Int, users: [UserProfileEntity]) {
        self.bookmarkCount = bookmarkCount
        self.users = users
    }
}
