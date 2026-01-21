//
//  BookmarkContentsListDTO.swift
//  Data
//
//  Created by 소은 on 1/21/26.
//

import Foundation

import Entity

public struct BookmarkContentsListDTO: Codable {
    public let contents: [ContentDTO]?
}

public extension BookmarkContentsListDTO {

    struct ContentDTO: Codable {
        public let id: Int?
        public let title: String?
        public let year: Int?
        public let getOttSimpleList: [OTTSimpleDTO]?
    }

    struct OTTSimpleDTO: Codable {
        public let ottName: String?
        public let logoUrl: String?
    }
}


extension BookmarkContentsListDTO {

    public var entity: BookmarkContentsListEntity {
        get throws {
            return try BookmarkContentsListEntity(
                contents: (contents ?? []).map { dto in
                    try dto.entity
                }
            )
        }
    }
}

extension BookmarkContentsListDTO.ContentDTO {

    public var entity: BookmarkContentsListEntity.BookmarkContentEntity {
        get throws {
            return try BookmarkContentsListEntity.BookmarkContentEntity(
                id: unwrap(id, key: CodingKeys.id),          // 필수만 unwrap
                title: title ?? "",
                year: year ?? 0,
                ottList: (getOttSimpleList ?? []).map { $0.entity }
            )
        }
    }
}

extension BookmarkContentsListDTO.OTTSimpleDTO {

    public var entity: BookmarkContentsListEntity.OTTSimpleEntity {
        return BookmarkContentsListEntity.OTTSimpleEntity(
            ottName: ottName ?? "",
            logoUrl: logoUrl ?? ""
        )
    }
}
