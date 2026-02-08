//
//  CollectionInfoEntity.swift
//  Domain
//
//  Created by 소은 on 1/22/26.
//

import Foundation

public struct CollectionInfoEntity {
    public let id: String
    public let imageUrl: URL?
    public let profileImageUrl: URL?
    public let title: String
    public let userName: String
    
    public init(id: String, imageUrl: URL?, profileImageUrl: URL?, title: String, userName: String) {
        self.id = id
        self.imageUrl = imageUrl
        self.profileImageUrl = profileImageUrl
        self.title = title
        self.userName = userName
    }
}
