//
//  SignupRequestDTO.swift
//  Data
//
//  Created by 김호성 on 2026.01.23.
//

import Foundation

import Entity

public struct SignupRequestDTO: Codable {
    public let tempToken: String
    public let nickname: String
    public let profileImage: String?
    public let favoriteContentIds: [Int] // Java Long
    public let agreedTermsIds: [String]
    
    public init(tempToken: String, nickname: String, profileImage: String?, favoriteContentIds: [Int], agreedTermsIds: [String]) {
        self.tempToken = tempToken
        self.nickname = nickname
        self.profileImage = profileImage
        self.favoriteContentIds = favoriteContentIds
        self.agreedTermsIds = agreedTermsIds
    }
}

extension SignupRequestDTO {
    public init(tempToken: String, signupEntity: SignupInfoEntity) {
        self.tempToken = tempToken
        self.nickname = signupEntity.nickname
        self.profileImage = signupEntity.profileImage
        self.favoriteContentIds = signupEntity.favoriteContentIds
        self.agreedTermsIds = signupEntity.agreedTermsIds
    }
}
