//
//  SessionDTO.swift
//  Data
//
//  Created by Hosung.Kim on 2026.10.14.
//

import Foundation

import Domain

public struct SessionDTO: Codable {
    public let items: [Item]?
    public let state: String?
    public let hasNext: Bool?
    public let lastViewedPosition: Int?
    public let canAdvance: Bool?
}

extension SessionDTO {
    public struct Item: Codable {
        public let contentId: String?
        public let title: String?
        public let description: String?
        public let imageUrl: String?
        public let year: Int?
        public let collectionId: String?
        public let position: Int?
    }
}

extension SessionEntity {
    package init(from dto: SessionDTO) throws {
        try self.init(
            items: dto.items.unwrap().map(ExploreInfoEntity.init),
            state: dto.state.unwrap(),
            hasNext: dto.hasNext.unwrap(),
            lastViewedPosition: dto.lastViewedPosition.unwrap(),
            canAdvance: dto.canAdvance ?? false
        )
    }
}

extension ExploreInfoEntity {
    package init(from dto: SessionDTO.Item) throws {
        try self.init(
            contentId: Int64(dto.contentId.unwrap()).unwrap(),
            collectionId: Int64(dto.collectionId.unwrap()).unwrap(),
            imageUrl: URL(string: dto.imageUrl.unwrap()).unwrap(),
            title: dto.title.unwrap(),
            description: dto.description.unwrap()
        )
    }
}
