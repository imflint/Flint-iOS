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
    public var entities: [ContentEntity] {
        get throws {
            return try contents?.map({ try $0.entity }) ?? []
        }
    }
}

extension SearchContentsDTO.ContentDTO {
    public var entity: ContentEntity {
        get throws {
            return try ContentEntity(
                id: unwrap(id),
                title: title ?? "",
                author: author ?? "",
                posterUrl: URL(string: posterUrl ?? ""),
                year: year ?? 0
            )
        }
    }
}
