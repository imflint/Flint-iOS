//
//  RecentViewedCollectionsDTO.swift
//  Data
//
//  Created by 소은 on 1/24/26.
//

import Foundation
import Entity

public struct RecentViewedCollectionsDTO: Codable {
    public let collections: [CollectionDTO]?
}

public extension RecentViewedCollectionsDTO {
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

public extension RecentViewedCollectionsDTO {
    var entities: [CollectionEntity] {
        get throws {
            return try collections?.compactMap { try $0.entity } ?? []
        }
    }
}

public extension RecentViewedCollectionsDTO.CollectionDTO {
    var entity: CollectionEntity {
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
