//
//  File.swift
//  Domain
//
//  Created by 소은 on 1/22/26.
//

import Foundation

public struct CollectionInfoEntity {
    public let imageURL: URL?
    public let profileImageURL: URL?
    public let title: String
    public let userName: String
    
    public init(imageURL: URL?, profileImageURL: URL?, title: String, userName: String) {
        self.imageURL = imageURL
        self.profileImageURL = profileImageURL
        self.title = title
        self.userName = userName
    }
}
