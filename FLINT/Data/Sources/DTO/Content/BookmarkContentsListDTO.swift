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
        return BookmarkContentsListEntity(
            contents: (contents ?? []).map { dto in
                BookmarkContentsListEntity.BookmarkContentEntity(
                    id: dto.id ?? 0,
                    title: dto.title ?? "",
                    year: dto.year ?? 0,
                    ottList: (dto.getOttSimpleList ?? []).map {
                        BookmarkContentsListEntity.OTTSimpleEntity(
                            ottName: $0.ottName ?? "",
                            logoUrl: $0.logoUrl ?? ""
                        )
                    }
                )
            }
        )
    }
}
