//
//  HomeRecommendedCollectionsEntity.swift
//  Domain
//
//  Created by 소은 on 1/20/26.
//

import Foundation

public struct HomeRecommendedCollectionsEntity {

    public let collections: [HomeRecommendedCollectionEntity]

    public init(collections: [HomeRecommendedCollectionEntity]) {
        self.collections = collections
    }
}

public extension HomeRecommendedCollectionsEntity {

    struct HomeRecommendedCollectionEntity {

        public let id: Int
        public let thumbnailUrl: String
        public let title: String
        public let description: String
        public let imageList: [String]
        public let bookmarkCount: Int
        public let isBookmarked: Bool
        public let userId: Int
        public let nickname: String
        public let profileUrl: String

        public init(
            id: Int,
            thumbnailUrl: String,
            title: String,
            description: String,
            imageList: [String],
            bookmarkCount: Int,
            isBookmarked: Bool,
            userId: Int,
            nickname: String,
            profileUrl: String
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
            self.profileUrl = profileUrl
        }
    }
}
