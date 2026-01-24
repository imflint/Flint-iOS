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
        public let profileUrl: String?
    }
}

public extension HomeRecommendedCollectionsDTO {
    var entities: [CollectionInfoEntity] {
        (collections ?? []).map { $0.entity }
    }
}

public extension HomeRecommendedCollectionsDTO.CollectionDTO {
    var entity: CollectionInfoEntity {
        CollectionInfoEntity(
            id: id ?? "",
            imageUrlString: thumbnailUrl ?? "",
            profileImageUrlString: profileUrl ?? "",
            title: title ?? "",
            userName: nickname ?? ""
        )
    }
}
