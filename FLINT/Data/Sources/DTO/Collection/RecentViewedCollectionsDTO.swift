//
//  RecentViewedCollectionsDTO.swift
//  Data
//
//  Created by 소은 on 1/24/26.
//

import Foundation

import Entity

public struct RecentViewedCollectionsDTO: Codable {
    public let collections: [CollectionDTO]?
}

extension RecentViewedCollectionsDTO {
    public var entities: [CollectionEntity] {
        get throws {
            return try collections?.compactMap { try $0.collectionEntity } ?? []
        }
    }
}
