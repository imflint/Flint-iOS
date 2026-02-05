//
//  CollectionBookmarkUsersDTO.swift
//  Entity
//
//  Created by 소은 on 1/23/26.
//

import Foundation

import Entity

public struct CollectionBookmarkUsersDTO: Codable {
    public let bookmarkCount: Int?
    public let userList: [UserDTO]?
}

public extension CollectionBookmarkUsersDTO {
    struct UserDTO: Codable {
        public let userId: String?
        public let nickName: String?
        public let profileImageUrl: String?
        public let userRole: String?
    }
}

extension CollectionBookmarkUsersDTO {
    public var entity: CollectionBookmarkUsersEntity {
        get throws {
            return try CollectionBookmarkUsersEntity(
                bookmarkCount: bookmarkCount ?? 0,
                users: userList?.map({ try $0.entity }) ?? []
            )
        }
    }
}

extension CollectionBookmarkUsersDTO.UserDTO {
    public var entity: CollectionBookmarkUserEntity {
        get throws {
            return try CollectionBookmarkUserEntity(
                userId: unwrap(userId),
                nickname: nickName ?? "",
                profileImageUrl: URL(string: profileImageUrl ?? ""),
                userRole: userRole ?? ""
            )
    }
}
