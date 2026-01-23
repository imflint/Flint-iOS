//
//  File.swift
//  Data
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

import Domain

public struct CollectionsDTO: Codable {
    public let data: [CollectionDTO]?
    public let meta: CollectionsMetaDTO?
    
    public init(data: [CollectionDTO]?, meta: CollectionsMetaDTO?) {
        self.data = data
        self.meta = meta
    }
}

extension CollectionsDTO {
    public struct CollectionDTO: Codable {
        public let collectionId: String?
        public let imageUrl: String?
        public let title: String?
        public let description: String?
        public let createdAt: String?
    }
}

extension CollectionsDTO {
    public struct CollectionsMetaDTO: Codable {
        public let type: String?
        public let returned: Int?
        public let nextCursor: String?
    }
}

extension CollectionsDTO {
    public var entity: CollectionPagingEntity {
        get throws {
            return try CollectionPagingEntity(
                collections: data?.map({ try $0.entity }) ?? [],
                cursor: unwrap(UInt(unwrap(meta?.nextCursor)))
            )
        }
    }
}

extension CollectionsDTO.CollectionDTO {
    public var entity: ExploreInfoEntity {
        get throws {
            return try ExploreInfoEntity(
                id: unwrap(collectionId, key: CodingKeys.collectionId),
                imageUrl: URL(string: imageUrl ?? ""),
                title: title ?? "",
                description: description ?? ""
            )
        }
    }
}
