//
//  FlinerCardItem.swift
//  Presentation
//
//  Created by 소은 on 5/1/26.
//

import Foundation
import Domain

public struct FlinerCardItem {
    let id: String
    let thumbnailUrl: URL?
    let curatorNickname: String
    let curatorProfileUrl: URL?
    let title: String
    let description: String
}

public extension FlinerCardItem {
    init(entity: CollectionEntity) {
        self.id = entity.id
        self.thumbnailUrl = entity.thumbnailUrl
        self.curatorNickname = entity.user.nickname
        self.curatorProfileUrl = entity.user.profileImageUrl
        self.title = entity.title
        self.description = entity.description
    }
}
