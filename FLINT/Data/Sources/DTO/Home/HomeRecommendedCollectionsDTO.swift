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

public extension HomeRecommendedCollectionsDTO {
    struct CollectionDTO: Codable {
        public let id: Int?
        public let thumbnailUrl: String?
        public let title: String?
        public let description: String?
        public let imageList: [String]?
        public let bookmarkCount: Int?
        public let isBookmarked: Bool?
        public let userId: Int?
        public let nickname: String?
        public let profileUrl: String?
    }
}

extension HomeRecommendedCollectionsDTO {
    public var entity: HomeRecommendedCollectionsEntity {
        return HomeRecommendedCollectionsEntity(
            collections: (collections ?? []).map {
                HomeRecommendedCollectionsEntity.HomeRecommendedCollectionEntity(
                    id: $0.id ?? 0,
                    thumbnailUrl: $0.thumbnailUrl ?? "",
                    title: $0.title ?? "",
                    description: $0.description ?? "",
                    imageList: $0.imageList ?? [],
                    bookmarkCount: $0.bookmarkCount ?? 0,
                    isBookmarked: $0.isBookmarked ?? false,
                    userId: $0.userId ?? 0,
                    nickname: $0.nickname ?? "",
                    profileUrl: $0.profileUrl ?? ""
                )
            }
        )
    }
}
