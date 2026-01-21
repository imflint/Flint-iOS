//
//  File.swift
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
    public var entity: LoginEntity {
        return LoginEntity(
            accessToken: accessToken ?? "",
            refreshToken: refreshToken ?? "",
            userId: userId ?? ""
        )
    }
}
