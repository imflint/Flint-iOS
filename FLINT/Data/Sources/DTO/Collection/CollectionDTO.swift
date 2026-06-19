//
//  CollectionDTO.swift
//  Data
//
//  Created by 김호성 on 2026.02.09.
//

import Foundation

import Entity

public struct CollectionDTO: Codable {
    public let id: String?
    public let thumbnailUrl: String?
    public let title: String?
    public let description: String?
    public let imageList: [String]?
    public let bookmarkCount: Int?
    public let isBookmarked: Bool?
    public let userId: String?
    public let nickname: String?
    public let profileImageUrl: String?
}

extension CollectionDTO {
    public var collectionEntity: CollectionEntity {
        get throws {
            return try CollectionEntity(
                id: unwrap(id),
                thumbnailUrl: URL(string: thumbnailUrl ?? ""),
                title: title ?? "",
                description: description ?? "",
                imageList: imageList?.compactMap({ URL(string: $0) }) ?? [],
                bookmarkCount: bookmarkCount ?? 0,
                isBookmarked: isBookmarked ?? false,
                user: UserProfileEntity(
                    id: userId ?? "",
                    nickname: nickname ?? "",
                    profileImageUrl: URL(string: profileImageUrl ?? ""),
                    role: .unknown
                )
            )
        }
    }
}
