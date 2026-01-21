//
//  RecentCollectionsDTO.swift
//  Data
//
//  Created by 소은 on 1/22/26.
//

import Foundation

import Entity

public struct RecentCollectionsDTO: Codable {
    public let collections: [CollectionDTO]?
}

public extension RecentCollectionsDTO {

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

extension RecentCollectionsDTO {

    public var entity: RecentCollectionsEntity {
        get throws {
            return try RecentCollectionsEntity(
                collections: (collections ?? []).map { dto in
                    try dto.entity
                }
            )
        }
    }
}

extension RecentCollectionsDTO.CollectionDTO {

    public var entity: RecentCollectionEntity {
        get throws {
            return try RecentCollectionEntity(
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
