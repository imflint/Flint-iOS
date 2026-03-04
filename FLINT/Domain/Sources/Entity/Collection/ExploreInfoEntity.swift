//
//  ExploreInfoEntity.swift
//  Domain
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

public struct ExploreInfoEntity: Identifiable, Hashable, Sendable {
    public let id: String
    public let collectionId: Int64
    public let imageUrl: URL?
    public let title: String
    public let description: String
    
    public init(collectionId: Int64, imageUrl: URL?, title: String, description: String) {
        id = UUID().uuidString
        self.collectionId = collectionId
        self.imageUrl = imageUrl
        self.title = title
        self.description = description
    }
}
