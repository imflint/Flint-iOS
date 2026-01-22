//
//  HomeRecommendedCollectionsDTO.swift
//  Data
//
//  Created by 소은 on 1/20/26.
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

// MARK: - DTO -> Entity

public extension RecentCollectionsDTO {
    var entities: [RecentCollectionEntity] {
        (collections ?? []).compactMap { $0.entity }
    }
}

public extension RecentCollectionsDTO.CollectionDTO {
    var entity: RecentCollectionEntity? {
        guard
            let id,
            let title,
            let description,
            let userId,
            let nickname
        else {
            return nil
        }
        
        return RecentCollectionEntity(
            id: id,
            thumbnailURL: thumbnailUrl.flatMap(URL.init(string:)),
            title: title,
            description: description,
            imageList: (imageList ?? []).compactMap(URL.init(string:)),
            bookmarkCount: bookmarkCount ?? 0,
            isBookmarked: isBookmarked ?? false,
            author: RecentCollectionAuthorEntity(
                userId: userId,
                nickname: nickname,
                profileImageURL: profileImageUrl.flatMap(URL.init(string:))
            )
        )
    }
}
