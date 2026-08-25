//
//  SearchContentsDTO.swift
//  Data
//
//  Created by 소은 on 1/20/26.
//

import Foundation

import Entity

public struct SearchContentsDTO: Codable {
    public let data: [ContentDTO]?
    public let meta: MetaDTO?
}

extension SearchContentsDTO {
    public struct ContentDTO: Codable {
        public let id: String?
        public let title: String?
        public let author: String?
        public let posterUrl: String?
        public let year: Int?
    }
}

extension SearchContentsDTO {
    public struct MetaDTO: Codable {
        public let type: String?
        public let returned: Int?
        public let nextCursor: String?
        public let page: Int?
        public let size: Int?
        public let totalElements: String?
        public let totalPages: Int?
    }
}

extension SearchContentsDTO {
    public var entity: SearchContentEntity {
        get throws {
            return try SearchContentEntity(
                data: data?.map({ try $0.entity }) ?? [],
                meta: (meta?.entity).unwrap()
            )
        }
    }
    
    // deprecated
    public var entities: [ContentEntity] {
        get throws {
            return try data?.map({ try $0.entity }) ?? []
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

extension SearchContentsDTO.MetaDTO {
    public var entity: SearchContentEntity.MetaEntity {
        get {
            return .init(
                type: type,
                returned: returned,
                nextCursor: nextCursor,
                page: page,
                size: size,
                totalElements: totalElements,
                totalPages: totalPages
            )
        }
    }
}
