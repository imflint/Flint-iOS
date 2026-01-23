//
//  File.swift
//  Data
//
//  Created by 김호성 on 2026.01.23.
//

import Foundation

import Domain

public struct SignupRequestDTO: Codable {
    public let tempToken: String
    public let nickname: String
    public let favoriteContentIds: [Int] // Java Long
    public let subscribedOttIds: [Int] // Java Long
    
    public init(tempToken: String, nickname: String, favoriteContentIds: [Int], subscribedOttIds: [Int]) {
        self.tempToken = tempToken
        self.nickname = nickname
        self.favoriteContentIds = favoriteContentIds
        self.subscribedOttIds = subscribedOttIds
    }
}

extension SignupRequestDTO {
    public init(tempToken: String, signupEntity: SignupInfoEntity) {
        self.tempToken = tempToken
        self.nickname = signupEntity.nickname
        self.favoriteContentIds = signupEntity.favoriteContentIds
        self.subscribedOttIds = signupEntity.subscribedOttIds
    }
}
