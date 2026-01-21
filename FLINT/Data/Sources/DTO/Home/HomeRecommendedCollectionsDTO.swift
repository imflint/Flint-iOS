//
//  HomeRecommendedCollectionsDTO.swift
//  Data
//
//  Created by 소은 on 1/20/26.
//

import Combine
import Foundation

import Entity

public struct HomeRecommendedCollectionsDTO: Codable {
    public let collections: [CollectionDTO]?
}

public extension HomeRecommendedCollectionsDTO {
    struct CollectionDTO: Codable {
        public let id: String?
        public let thumbnailUrl: String?
        public let title: String?
        public let description: String?
        public let imageList: [String]?
        public let bookmarkCount: Int?
        public let isBookmarked: Bool?
        public let userId: String?
        public let nickname: String?
        public let profileImageUrl: String?
    }
}

extension HomeRecommendedCollectionsDTO {
    public var entity: HomeRecommendedCollectionsEntity {
        get throws {
            return try HomeRecommendedCollectionsEntity(
                collections: collections?.map({ try $0.entity }) ?? []
            )
        }
    }
}

extension HomeRecommendedCollectionsDTO.CollectionDTO {
    public var entity: HomeRecommendedCollectionsEntity.HomeRecommendedCollectionEntity {
        get throws {
            return try HomeRecommendedCollectionsEntity.HomeRecommendedCollectionEntity(
                id: unwrap(id, key: CodingKeys.id),
                thumbnailUrl: thumbnailUrl ?? "",
                title: title ?? "",
                description: description ?? "",
                imageList: imageList ?? [],
                bookmarkCount: bookmarkCount ?? 0,
                isBookmarked: isBookmarked ?? false,
                userId: unwrap(userId, key: CodingKeys.userId),
                nickname: nickname ?? "",
                profileImageUrl: profileImageUrl ?? ""
            )
        }
    }
}
