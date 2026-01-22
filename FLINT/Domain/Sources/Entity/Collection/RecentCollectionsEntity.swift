//
//  RecentCollectionsEntity.swift
//  Domain
//
//  Created by 소은 on 1/22/26.
//

import Foundation

public struct RecentCollectionsEntity: Equatable {
    public let collections: [RecentCollectionEntity]

    public init(collections: [RecentCollectionEntity]) {
        self.collections = collections
    }
}

public struct RecentCollectionEntity: Equatable, Identifiable {
    public let id: String

    public let thumbnailURL: URL?

    public let title: String
    public let description: String

    public let imageList: [URL]

    public let bookmarkCount: Int
    public let isBookmarked: Bool

    public let author: RecentCollectionAuthorEntity

    public init(
        id: String,
        thumbnailURL: URL?,
        title: String,
        description: String,
        imageList: [URL],
        bookmarkCount: Int,
        isBookmarked: Bool,
        author: RecentCollectionAuthorEntity
    ) {
        self.id = id
        self.thumbnailURL = thumbnailURL
        self.title = title
        self.description = description
        self.imageList = imageList
        self.bookmarkCount = bookmarkCount
        self.isBookmarked = isBookmarked
        self.author = author
    }
}

public struct RecentCollectionAuthorEntity: Equatable {
    public let userId: String
    public let nickname: String
    public let profileImageURL: URL?

    public init(
        userId: String,
        nickname: String,
        profileImageURL: URL?
    ) {
        self.userId = userId
        self.nickname = nickname
        self.profileImageURL = profileImageURL
    }
}

