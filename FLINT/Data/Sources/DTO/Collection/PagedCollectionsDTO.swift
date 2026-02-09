//
//  PagedCollectionsDTO.swift
//  Data
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

import Entity

public struct PagedCollectionsDTO: Codable {
    public let data: [CollectionDTO]?
    public let meta: CollectionsMetaDTO?
}

extension PagedCollectionsDTO {
    public struct CollectionDTO: Codable {
        public let collectionId: String?
        public let imageUrl: String?
        public let contentTitle: String?
        public let contentDescription: String?
    }
}

extension PagedCollectionsDTO {
    public struct CollectionsMetaDTO: Codable {
        public let type: String?
        public let returned: Int?
        public let nextCursor: String?
    }
}

extension PagedCollectionsDTO {
    public var entity: CollectionPagingEntity {
        get throws {
            return try CollectionPagingEntity(
                collections: data?.map({ try $0.entity }) ?? [],
                cursor: unwrap(Int64(meta?.nextCursor ?? ""))
            )
        }
    }
}

extension PagedCollectionsDTO.CollectionDTO {
    public var entity: ExploreInfoEntity {
        get throws {
            return try ExploreInfoEntity(
                id: unwrap(collectionId),
                imageUrl: URL(string: imageUrl ?? ""),
                title: contentTitle ?? "",
                description: contentDescription ?? ""
            )
        }
    }
}
