//
//  NicknameCheckDTO.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.19.
//

import Foundation

import Entity

public struct NicknameCheckDTO: Codable {
    public let available: Bool?
}

extension NicknameCheckDTO {
    public var entity: NicknameCheckEntity {
        get throws {
            return try NicknameCheckEntity(
                available: unwrap(available, key: CodingKeys.available)
            )
        }
    }
}
