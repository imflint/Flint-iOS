//
//  File.swift
//  Domain
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

public struct CollectionInfoEntity {
    public let id: String
    public let imageUrl: URL?
    public let title: String
    public let description: String
    
    public init(id: String, imageUrl: URL?, title: String, description: String) {
        self.id = id
        self.imageUrl = imageUrl
        self.title = title
        self.description = description
    }
}
