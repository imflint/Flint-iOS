//
//  ContentsDTO.swift
//  Data
//
//  Created by 진소은 on 1/23/26.
//

import Foundation

import Entity

public struct ContentsDTO: Codable {
    public let data: [ContentDTO]?
    public let meta: MetaDTO?
}

public struct MetaDTO: Codable {
    public let type: String?
    public let returned: Int?
    public let nextCursor: String?
    public let page: Int?
    public let size: Int?
    public let totalElements: String?
    public let totalPages: Int?
}

extension ContentsDTO {
    public struct ContentDTO: Codable {
        public let id: String?
        public let title: String?
        public let imageUrl: String?
        public let year: Int?
        public let bookmarkCount: Int?
        public let getOttSimpleList: [OttSimpleDTO]?
    }
    
    public struct OttSimpleDTO: Codable {
        public let ottName: String?
        public let logoUrl: String?
    }
}

extension ContentsDTO {
    public var entities: [ContentInfoEntity] {
        get throws {
            return try data?.map { try $0.entity } ?? []
        }
    }
}

extension ContentsDTO.ContentDTO {
    public var entity: ContentInfoEntity {
        get throws {
            return try ContentInfoEntity(
                id: unwrap(id),
                title: title ?? "",
                imageUrl: imageUrl ?? "",
                year: year ?? 0,
                ottList: getOttSimpleList?.map { try $0.entity } ?? []
            )
        }
    }
}

extension ContentsDTO.OttSimpleDTO {
    public var entity: OttSimpleEntity {
        get throws {
            return try OttSimpleEntity(
                ottName: unwrap(ottName),
                logoUrl: logoUrl ?? ""
            )
        }
    }
}
