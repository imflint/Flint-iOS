//
//  WatchiingCollectionDTO.swift
//  Data
//
//  Created by 소은 on 1/24/26.
//

import Foundation
import Entity

public struct WatchingCollectionsDTO: Codable {
    public let collections: [CollectionDTO]?
}

public extension WatchingCollectionsDTO {

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

// DTO -> Entity
public extension WatchingCollectionsDTO {
    var entities: [CollectionEntity] {
        (collections ?? []).compactMap { $0.entity }
    }
}

public extension WatchingCollectionsDTO.CollectionDTO {
    var entity: CollectionEntity? {
        guard let id, let title, let userId, let nickname else { return nil }

        return CollectionEntity(
            id: id,
            thumbnailUrl: thumbnailUrl ?? "",
            title: title,
            description: description ?? "",
            imageList: imageList ?? [],
            bookmarkCount: bookmarkCount ?? 0,
            isBookmarked: isBookmarked ?? false,
            userId: userId,
            nickname: nickname,
            profileImageUrl: profileImageUrl ?? ""
        )
    }
}
