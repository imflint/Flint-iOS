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
    public var entities: [CollectionInfoEntity] {
        get throws {
            return try collections?.map { try $0.collectionInfoEntity } ?? []
        }
    }
}
