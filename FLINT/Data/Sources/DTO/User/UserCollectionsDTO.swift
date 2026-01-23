//
//  UserCollectionsDTO.swift
//  Data
//
//  Created by 진소은 on 1/23/26.
//

import Foundation

import Entity

public struct UserCollectionsDTO: Codable {
    public let collections: [CollectionDTO]?
}

public extension UserCollectionsDTO {
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

public extension UserCollectionsDTO.CollectionDTO {
    var entity: CollectionEntity {
        get throws {
            return try CollectionEntity(
                id: unwrap(id, key: CodingKeys.id),
                thumbnailUrl: thumbnailUrl ?? "",
                title: title ?? "",
                description: description ?? "",
                imageList: imageList ?? [],
                bookmarkCount: bookmarkCount ?? 0,
                isBookmarked: isBookmarked ?? false,
                userId: userId ?? "",
                nickname: nickname ?? "",
                profileImageUrl: profileImageUrl ?? ""
            )
        }
    }
}
