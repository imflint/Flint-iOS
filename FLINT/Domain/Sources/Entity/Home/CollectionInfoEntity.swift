//
//  File.swift
//  Domain
//
//  Created by 소은 on 1/22/26.
//

import Foundation

public struct CollectionInfoEntity {
    public let imageUrlString: String
    public let profileImageUrlString: String
    public let title: String
    public let userName: String

    public init(
        imageUrlString: String,
        profileImageUrlString: String,
        title: String,
        userName: String
    ) {
        self.imageUrlString = imageUrlString
        self.profileImageUrlString = profileImageUrlString
        self.title = title
        self.userName = userName
    }

    public var imageURL: URL? { URL(string: imageUrlString) }
    public var profileImageURL: URL? { URL(string: profileImageUrlString) }
}
