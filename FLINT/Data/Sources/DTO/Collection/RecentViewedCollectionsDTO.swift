//
//  RecentViewedCollectionsDTO.swift
//  Data
//
//  Created by 소은 on 1/24/26.
//

import Foundation

import Entity

// TODO: - RecentViewedCollectionsDTO & HomeRecommendedCollectionsDTO & UserCollectionsDTO 유사

public struct RecentViewedCollectionsDTO: Codable {
    public let collections: [CollectionDTO]?
}

extension RecentViewedCollectionsDTO {
    public struct CollectionDTO: Codable {
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

extension RecentViewedCollectionsDTO {
    public var entities: [CollectionEntity] {
        get throws {
            return try collections?.compactMap { try $0.entity } ?? []
        }
    }
}

extension RecentViewedCollectionsDTO.CollectionDTO {
    public var entity: CollectionEntity {
        get throws {
            return try CollectionEntity(
                id: unwrap(id),
                thumbnailUrl: thumbnailUrl ?? "",
                title: title ?? "",
                description: description ?? "",
                imageList: imageList ?? [],
                bookmarkCount: bookmarkCount ?? 0,
                isBookmarked: isBookmarked ?? false,
                userId: unwrap(userId),
                nickname: nickname ?? "",
                profileImageUrl: profileImageUrl ?? ""
            )
        }
    }
}
