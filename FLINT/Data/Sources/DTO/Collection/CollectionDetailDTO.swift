//
//  CollectionDetailDTO.swift
//  Data
//
//  Created by 진소은 on 1/23/26.
//

import Foundation

import Entity

public struct CollectionDetailDTO: Codable {
    public let id: String?
    public let title: String?
    public let description: String?
    public let thumbnailUrl: String?
    public let createdAt: String?
    public let isBookmarked: Bool?
    public let author: AuthorDTO?
    public let contents: [ContentDTO]?
}

extension CollectionDetailDTO {
    public struct AuthorDTO: Codable {
        public let id: String?
        public let nickname: String?
        public let profileImageUrl: String?
        public let userRole: String?
    }
    
    public struct ContentDTO: Codable {
        public let id: String?
        public let title: String?
        public let imageUrl: String?
        public let customImageUrls: [String]?
        public let director: String?
        public let isBookmarked: Bool?
        public let bookmarkCount: Int?
        public let isSpoiler: Bool?
        public let reason: String?
        public let year: Int?
    }
}

extension CollectionDetailDTO {
    public var entity: CollectionDetailEntity {
        get throws {
            return try CollectionDetailEntity(
                id: unwrap(id),
                title: title ?? "",
                description: description ?? "",
                thumbnailUrl: URL(string: thumbnailUrl ?? ""),
                createdAt: createdAt ?? "",
                isBookmarked: isBookmarked ?? false,
                author: unwrap(author?.entity),
                contents: contents?.map { try $0.entity } ?? []
            )
        }
    }
}

extension CollectionDetailDTO.AuthorDTO {
    public var entity: UserProfileEntity {
        get throws {
            return try UserProfileEntity(
                id: unwrap(id),
                nickname: nickname ?? "",
                email: "",
                profileImageUrl: URL(string: profileImageUrl ?? ""),
                role: UserRole(rawValue: userRole ?? "") ?? .unknown
            )
        }
    }
}

private extension String {
    var asURL: URL? {
        if let url = URL(string: self) { return url }
        if let encoded = addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: encoded) { return url }
        return nil
    }
}

extension CollectionDetailDTO.ContentDTO {
    public var entity: CollectionDetailEntity.CollectionContentEntity {
        get throws {
            return try CollectionDetailEntity.CollectionContentEntity(
                id: unwrap(id),
                title: title ?? "",
                imageUrl: URL(string: imageUrl ?? ""),
                customImageUrls: customImageUrls?.compactMap(\.asURL) ?? [],
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
