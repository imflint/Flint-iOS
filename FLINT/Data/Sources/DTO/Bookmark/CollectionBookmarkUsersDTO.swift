//
//  CollectionBookmarkUsersDTO.swift
//  Entity
//
//  Created by 소은 on 1/23/26.
//

import Foundation

import Entity

public struct CollectionBookmarkUsersDTO: Codable {
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
public extension CollectionBookmarkUsersDTO {

    struct DataDTO: Codable {
        public let bookmarkCount: Int?
        public let userList: [UserDTO]?

        public init(bookmarkCount: Int?, userList: [UserDTO]?) {
            self.bookmarkCount = bookmarkCount
            self.userList = userList
        }
    }

    struct UserDTO: Codable {
        public let userId: String?
        public let nickName: String?
        public let profileImageUrl: String?
        public let userRole: String?

        public init(userId: String?, nickName: String?, profileImageUrl: String?, userRole: String?) {
            self.userId = userId
            self.nickName = nickName
            self.profileImageUrl = profileImageUrl
            self.userRole = userRole
        }
    }
}

extension CollectionBookmarkUsersDTO {
    public var entity: CollectionBookmarkUsersEntity {
        get throws {
            return try unwrap(data).entity
        }
    }
}

extension CollectionBookmarkUsersDTO.DataDTO {
    public var entity: CollectionBookmarkUsersEntity {
        get throws {
            return CollectionBookmarkUsersEntity(
                bookmarkCount: bookmarkCount ?? 0,
                users: try (userList ?? []).map { try $0.entity }
            )
        }
    }
}

extension CollectionBookmarkUsersDTO.UserDTO {
    public var entity: CollectionBookmarkUserEntity {
        get throws {
            return CollectionBookmarkUserEntity(
                userId: userId ?? "",
                nickname: nickName ?? "",
                profileImageUrl: URL(string: profileImageUrl ?? ""),
                userRole: userRole ?? ""
            )
        }
    }
}
