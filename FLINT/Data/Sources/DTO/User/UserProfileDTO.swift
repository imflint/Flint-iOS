//
//  UserProfileDTO.swift
//  Data
//
//  Created by 진소은 on 1/22/26.
//

import Foundation

import Entity

public struct UserProfileDTO: Codable {
    public let id: String?
    public let nickname: String?
    public let profileImageUrl: String?
    public let isFliner: Bool?
}

extension UserProfileDTO {
    public var entity: UserProfileEntity {
        get throws {
            return try UserProfileEntity(
                id: unwrap(id, key: CodingKeys.id),
                nickname: nickname ?? "",
                profileImageUrl: profileImageUrl ?? "",
                isFliner: isFliner ?? false
            )
        }
    }
}
