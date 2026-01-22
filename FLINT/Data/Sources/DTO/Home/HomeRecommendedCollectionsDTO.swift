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
    public var entity: [CollectionInfoEntity] {
        get throws {
            return try collections?.map { try $0.entity } ?? []
        }
    }
}

extension HomeRecommendedCollectionsDTO.CollectionDTO {
    public var entity: CollectionInfoEntity {
        get throws {
            return CollectionInfoEntity(
                imageURL: URL(string: thumbnailUrl ?? ""),
                profileImageURL: URL(string: profileImageUrl ?? ""),
                title: title ?? "",
                userName: nickname ?? ""
            )
                
        }
    }
}
