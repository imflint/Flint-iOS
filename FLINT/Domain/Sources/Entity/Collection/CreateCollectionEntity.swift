//
//  CreateCollectionEntity.swift
//  Domain
//
//  Created by 소은 on 1/20/26.
//

import Foundation

public struct CreateCollectionEntity: Encodable {
    public let imageUrl: String
    public let title: String
    public let description: String
    public let isPublic: Bool
    public let contentList: [CreateCollectionContents]
    
    public init(imgaeUrl: String,
                title: String,
                description: String,
                isPublic: Bool,
                contentList: [CreateCollectionContents]
    ) {
        self.imageUrl = imgaeUrl
        self.title = title
        self.description = description
        self.isPublic = isPublic
        self.contentList = contentList
    }
}

public extension CreateCollectionEntity {
    
    struct CreateCollectionContents: Encodable {
        public let contentId: Int64
        public let isSpoiler: Bool
        public let reason: String
        
        public init(contentId: Int64,
                    isSpoiler: Bool,
                    reason: String
        ) {
            self.contentId = contentId
            self.isSpoiler = isSpoiler
            self.reason = reason
        }
    }
}
