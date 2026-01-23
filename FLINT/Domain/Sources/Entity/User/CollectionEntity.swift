//
//  CollectionEntity.swift
//  Domain
//
//  Created by 진소은 on 1/23/26.
//

import Foundation

public struct CollectionEntity: Equatable {
    public let id: String
    public let thumbnailUrl: String
    public let title: String
    public let description: String
    public let imageList: [String]
    public let bookmarkCount: Int
    public let isBookmarked: Bool
    public let userId: String
    public let nickname: String
    public let profileImageUrl: String

    public init(
        id: String,
        thumbnailUrl: String,
        title: String,
        description: String,
        imageList: [String],
        bookmarkCount: Int,
        isBookmarked: Bool,
        userId: String,
        nickname: String,
        profileImageUrl: String
    ) {
        self.id = id
        self.thumbnailUrl = thumbnailUrl
        self.title = title
        self.description = description
        self.imageList = imageList
        self.bookmarkCount = bookmarkCount
        self.isBookmarked = isBookmarked
        self.userId = userId
        self.nickname = nickname
        self.profileImageUrl = profileImageUrl
    }
}
