//
//  KeywordDTO.swift
//  Data
//
//  Created by 진소은 on 1/22/26.
//

import Foundation

import Entity

public struct KeywordsDTO: Codable {
    public let keywords: [KeywordDTO]?
}

extension KeywordsDTO {
    public struct KeywordDTO: Codable {
        public let color: String?
        public let rank: Int?
        public let name: String?
        public let percentage: Int?
        public let imageUrl: String?
    }
}

extension KeywordsDTO {
    public var entities: [KeywordEntity] {
        get throws {
            return try keywords?.map { try $0.entity } ?? []
        }
    }
}

extension KeywordsDTO.KeywordDTO {
    public var entity: KeywordEntity {
        get throws {
            return try KeywordEntity(
                color: unwrap(KeywordColor(rawValue: color ?? "")),
                rank: unwrap(rank),
                name: name ?? "",
                percentage: percentage ?? 0,
                imageUrl: URL(string: imageUrl ?? "")
            )
        }
    }
}
