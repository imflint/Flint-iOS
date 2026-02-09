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

extension UserCollectionsDTO {
    public var entities: [CollectionEntity] {
        get throws {
            return try collections?.map { try $0.collectionEntity } ?? []
        }
    }
}
