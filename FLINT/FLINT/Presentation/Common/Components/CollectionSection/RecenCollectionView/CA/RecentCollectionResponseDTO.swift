//
//  RecentCollectionResponseDTO.swift
//  FLINT
//
//  Created by 소은 on 1/11/26.
//

import Foundation

struct RecentCollectionResponseDTO: Decodable {
    let items: [RecentCollectionItemDTO]
}

struct RecentCollectionItemDTO: Decodable {
    let id: String
    let imageUrl: String?
    let title: String
    let userName: String
    let profileImageUrl: String?
}
