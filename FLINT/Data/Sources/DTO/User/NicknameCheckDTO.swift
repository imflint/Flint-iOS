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
    public var isAvailable: Bool {
        get throws {
            return try unwrap(available, key: CodingKeys.available)
        }
    }
}
