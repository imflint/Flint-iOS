//
//  ContentsDTO.swift
//  Data
//
//  Created by 진소은 on 1/23/26.
//

import Foundation

import Entity

public struct ContentsDTO: Codable {
    public let contents: [ContentDTO]?
}

public extension ContentsDTO {
    struct ContentDTO: Codable {
        public let id: String?
        public let title: String?
        public let imageUrl: String?
        public let year: Int?
        public let getOttSimpleList: [OttSimpleDTO]?
    }

    struct OttSimpleDTO: Codable {
        public let ottName: String?
        public let logoUrl: String?
    }
}

// MARK: - DTO -> Entity

public extension ContentsDTO.ContentDTO {
    var entity: ContentInfoEntity {
        get throws {
            return try ContentInfoEntity(
                id: unwrap(id, key: CodingKeys.id),
                title: title ?? "",
                imageUrl: imageUrl ?? "",
                year: year ?? 0,
                ottList: try (getOttSimpleList ?? []).map { try $0.entity }
            )
        }
    }
}

public extension ContentsDTO.OttSimpleDTO {
    var entity: OttSimpleEntity {
        get throws {
            return try OttSimpleEntity(
                ottName: unwrap(ottName, key: CodingKeys.ottName),
                logoUrl: logoUrl ?? ""
            )
        }
    }
}
