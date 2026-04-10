//
//  HomeRecommendedCollectionsDTO.swift
//  Data
//
//  Created by 소은 on 1/20/26.
//

import Foundation

import Entity

public struct CollectionsDTO: Codable {
    public let collections: [CollectionDTO]?
}

extension CollectionsDTO {
    public var entities: [CollectionEntity] {
        get throws {
            return try collections?.map { try $0.collectionEntity } ?? []
        }
    }
}
