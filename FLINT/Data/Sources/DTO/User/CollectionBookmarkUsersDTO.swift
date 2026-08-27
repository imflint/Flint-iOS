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

extension CollectionBookmarkUsersDTO {
    public struct UserDTO: Codable {
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
    public var entity: UserProfileEntity {
        get throws {
            return try UserProfileEntity(
                id: unwrap(userId),
                nickname: nickName ?? "",
                email: "",
                profileImageUrl: URL(string: profileImageUrl ?? ""),
                role: UserRole(rawValue: userRole ?? "") ?? .unknown
            )
        }
    }
}
