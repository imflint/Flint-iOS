//
//  CollectionEntity.swift
//  Domain
//
//  Created by 진소은 on 1/23/26.
//

import Foundation

public struct CollectionEntity: Equatable {
    public let id: String
    public let thumbnailUrl: URL?
    public let title: String
    public let description: String
    public let imageList: [URL]
    public let bookmarkCount: Int
    public let isBookmarked: Bool
    public let user: UserProfileEntity
    
    public init(id: String, thumbnailUrl: URL?, title: String, description: String, imageList: [URL], bookmarkCount: Int, isBookmarked: Bool, user: UserProfileEntity) {
        self.id = id
        self.thumbnailUrl = thumbnailUrl
        self.title = title
        self.description = description
        self.imageList = imageList
        self.bookmarkCount = bookmarkCount
        self.isBookmarked = isBookmarked
        self.user = user
    }
}
