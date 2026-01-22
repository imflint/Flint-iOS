//
//  MoreNoMoreCollectionItem.swift
//  FLINT
//
//  Created by 소은 on 1/16/26.
//

import UIKit

public struct MoreNoMoreCollectionItem: Equatable {
    public let image: UIImage?
    public let profileImage: UIImage?
    public let title: String
    public let userName: String

    public init(image: UIImage?, profileImage: UIImage?, title: String, userName: String) {
        self.image = image
        self.profileImage = profileImage
        self.title = title
        self.userName = userName
    }
}
