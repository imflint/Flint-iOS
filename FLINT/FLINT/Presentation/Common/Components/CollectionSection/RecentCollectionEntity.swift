//
//  RecentCollectionEntity.swift
//  FLINT
//
//  Created by 소은 on 1/11/26.
//

import Foundation

struct RecentCollectionEntity: Hashable {
    let id: UUID
    let title: String
    let userName: String
    let imageName: String?
    let profileImageName: String?
}
