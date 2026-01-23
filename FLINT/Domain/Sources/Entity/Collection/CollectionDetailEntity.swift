//
//  CollectionDetailEntity.swift
//  Domain
//
//  Created by 진소은 on 1/23/26.
//

import Foundation

public struct CollectionDetailEntity: Equatable {
    public let id: String
    public let title: String
    public let description: String
    public let thumbnailUrl: URL?
    public let createdAt: String
    public let isBookmarked: Bool
    public let author: CollectionAuthorEntity?
    public let contents: [CollectionContentEntity]

    public init(
        id: String,
        title: String,
        description: String,
        thumbnailUrl: URL?,
        createdAt: String,
        isBookmarked: Bool,
        author: CollectionAuthorEntity?,
        contents: [CollectionContentEntity]
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.thumbnailUrl = thumbnailUrl
        self.createdAt = createdAt
        self.isBookmarked = isBookmarked
        self.author = author
        self.contents = contents
    }
}

public struct CollectionAuthorEntity: Equatable {
    public let id: String
    public let nickname: String
    public let profileImageUrl: URL?
    public let userRole: String

    public init(
        id: String,
        nickname: String,
        profileImageUrl: URL?,
        userRole: String
    ) {
        self.id = id
        self.nickname = nickname
        self.profileImageUrl = profileImageUrl
        self.userRole = userRole
    }
}

public struct CollectionContentEntity: Equatable {
    public let id: String
    public let title: String
    public let imageUrl: URL?
    public let director: String
    public let isBookmarked: Bool
    public let bookmarkCount: Int
    public let isSpoiler: Bool
    public let reason: String
    public let year: Int

    public init(
        id: String,
        title: String,
        imageUrl: URL?,
        director: String,
        isBookmarked: Bool,
        bookmarkCount: Int,
        isSpoiler: Bool,
        reason: String,
        year: Int
    ) {
        self.id = id
        self.title = title
        self.imageUrl = imageUrl
        self.director = director
        self.isBookmarked = isBookmarked
        self.bookmarkCount = bookmarkCount
        self.isSpoiler = isSpoiler
        self.reason = reason
        self.year = year
    }
}
