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
        return SearchContentsEntity(
            contents: (contents ?? []).map {
                SearchContentsEntity.SearchContent(
                    id: $0.id ?? "",
                    title: $0.title ?? "",
                    author: $0.author ?? "",
                    posterUrl: $0.posterUrl ?? "",
                    year: $0.year ?? 0
                )
            }
        )
    }
}
