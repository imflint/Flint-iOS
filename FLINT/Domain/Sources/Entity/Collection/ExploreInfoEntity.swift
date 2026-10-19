//
//  ExploreInfoEntity.swift
//  Domain
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

public struct ExploreInfoEntity: Hashable, Sendable {
    public let contentId: Int64
    public let collectionId: Int64
    public let imageUrl: URL?
    public let title: String
    public let description: String
    
    public init(contentId: Int64, collectionId: Int64, imageUrl: URL?, title: String, description: String) {
        self.contentId = contentId
        self.collectionId = collectionId
        self.imageUrl = imageUrl
        self.title = title
        self.description = description
    }
}

extension ExploreInfoEntity: Identifiable {
    public var id: String { String(contentId) }
}
