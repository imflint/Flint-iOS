//
//  SearchContentsDTO.swift
//  Data
//
//  Created by 소은 on 1/20/26.
//

import Foundation

import Entity

public struct SearchContentsDTO: Codable {
    public let contents: [ContentDTO]?
}

public extension SearchContentsDTO {
    struct ContentDTO: Codable {
        public let id: String?
        public let title: String?
        public let author: String?
        public let posterUrl: String?
        public let year: Int?
    }
}

extension SearchContentsDTO {
    public var entity: SearchContentsEntity {
        get throws {
            return try SearchContentsEntity(
                contents: contents?.map { try $0.entity } ?? []
            )
        }
    }
}

extension SearchContentsDTO.ContentDTO {
    public var entity: SearchContentsEntity.SearchContent {
        get throws {
            return try SearchContentsEntity.SearchContent(
                id: unwrap(id, key: CodingKeys.id),
                title: title ?? "",
                author: author ?? "",
                posterUrl: URL(string: posterUrl ?? ""),
                year: year ?? 0
            )
        }
    }
}
