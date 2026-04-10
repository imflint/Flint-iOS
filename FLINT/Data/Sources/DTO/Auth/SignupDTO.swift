//
//  SignupDTO.swift
//  Data
//
//  Created by 김호성 on 2026.01.21.
//

import Foundation

import Entity

public struct SignupDTO: Codable {
    public let accessToken: String?
    public let refreshToken: String?
    public let userId: String?
}

extension SignupDTO {
    public var loginEntity: LoginEntity {
        get throws {
            return try LoginEntity(
                accessToken: unwrap(accessToken),
                refreshToken: unwrap(refreshToken),
                userId: unwrap(userId)
            )
        }
    }
    
    public var userIdValue: String {
        get throws {
            return try unwrap(userId)
        }
    }
}
