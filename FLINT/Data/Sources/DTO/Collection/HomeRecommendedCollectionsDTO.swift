//
//  HomeRecommendedCollectionsDTO.swift
//  Data
//
//  Created by 소은 on 1/20/26.
//

import Foundation

import Entity

public struct HomeRecommendedCollectionsDTO: Codable {
    public let collections: [CollectionDTO]?
}

extension HomeRecommendedCollectionsDTO {
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
        public let profileUrl: String?
    }
}

extension HomeRecommendedCollectionsDTO {
    public var entities: [CollectionInfoEntity] {
        get throws {
            return try collections?.map { try $0.entity } ?? []
        }
    }
}

extension HomeRecommendedCollectionsDTO.CollectionDTO {
    public var entity: CollectionInfoEntity {
        get throws {
            return try CollectionInfoEntity(
                id: unwrap(id),
                imageUrl: URL(string: thumbnailUrl ?? ""),
                profileImageUrl: URL(string: profileUrl ?? ""),
                title: title ?? "",
                userName: nickname ?? ""
            )
        }
    }
}
