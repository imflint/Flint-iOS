//
//  KeywordDTO.swift
//  Data
//
//  Created by 진소은 on 1/22/26.
//

import Foundation

import Entity
// Data 모듈

public struct KeywordsDTO: Codable {
    public let keywords: [KeywordDTO]?
}

public struct KeywordDTO: Codable {
    public let color: String?
    public let rank: Int?
    public let name: String?
    public let percentage: Int?
    public let imageUrl: String?
}

extension KeywordDTO {
    public var entity: KeywordEntity {
        get throws {
            return try KeywordEntity(
                color: color ?? "",
                rank: unwrap(rank, key: CodingKeys.rank),
                name: name ?? "",
                percentage: percentage ?? 0,
                imageUrl: imageUrl ?? ""
            )
        }
    }
}
