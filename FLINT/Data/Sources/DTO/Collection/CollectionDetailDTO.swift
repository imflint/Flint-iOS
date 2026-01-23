//
//  CollectionDetailDTO.swift
//  Data
//
//  Created by 진소은 on 1/23/26.
//

import Foundation

import Entity

public struct CollectionDetailDTO: Codable {

    public let status: Int?
    public let message: String?
    public let data: DataDTO?

    public init(status: Int?, message: String?, data: DataDTO?) {
        self.status = status
        self.message = message
        self.data = data
    }
}

// MARK: - Nested DTOs

public extension CollectionDetailDTO {

    struct DataDTO: Codable {
        public let id: String?
        public let title: String?
        public let description: String?
        public let thumbnailUrl: String?
        public let createdAt: String?
        public let isBookmarked: Bool?
        public let author: AuthorDTO?
        public let contents: [ContentDTO]?
    }

    struct AuthorDTO: Codable {
        public let id: String?
        public let nickname: String?
        public let profileImageUrl: String?
        public let userRole: String?
    }

    struct ContentDTO: Codable {
        public let id: String?
        public let title: String?
        public let imageUrl: String?
        public let director: String?
        public let isBookmarked: Bool?
        public let bookmarkCount: Int?
        public let isSpoiler: Bool?
        public let reason: String?
        public let year: Int?
    }
}

extension CollectionDetailDTO.DataDTO {
    public var entity: CollectionDetailEntity {
        get throws {
            return try CollectionDetailEntity(
                id: unwrap(id),
                title: title ?? "",
                description: description ?? "",
                thumbnailUrl: URL(string: thumbnailUrl ?? ""),
                createdAt: createdAt ?? "",
                isBookmarked: isBookmarked ?? false,
                author: try author?.entity,
                contents: try (contents ?? []).map { try $0.entity }
            )
        }
    }
}

extension CollectionDetailDTO.AuthorDTO {
    public var entity: CollectionAuthorEntity {
        get throws {
            return try CollectionAuthorEntity(
                id: unwrap(id),
                nickname: nickname ?? "",
                profileImageUrl: URL(string: profileImageUrl ?? ""),
                userRole: userRole ?? ""
            )
        }
    }
}

extension CollectionDetailDTO.ContentDTO {
    public var entity: CollectionContentEntity {
        get throws {
            return try CollectionContentEntity(
                id: unwrap(id),
                title: title ?? "",
                imageUrl: URL(string: imageUrl ?? ""),
                director: director ?? "",
                isBookmarked: isBookmarked ?? false,
                bookmarkCount: bookmarkCount ?? 0,
                isSpoiler: isSpoiler ?? false,
                reason: reason ?? "",
                year: year ?? 0
            )
        }
    }
}
