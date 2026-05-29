//
//  SignupInfoEntity.swift
//  Domain
//
//  Created by 김호성 on 2026.01.21.
//

import Foundation

public struct SignupInfoEntity: Codable {
    public let nickname: String
    public let profileImage: String?
    public let favoriteContentIds: [Int] // Java Long
    public let agreedTermsIds: [String]
//    public let subscribedOttIds: [Int]
    
    public init(nickname: String, profileImage: String?, favoriteContentIds: [Int], agreedTermsIds: [String]) {
        self.nickname = nickname
        self.profileImage = profileImage
        self.favoriteContentIds = favoriteContentIds
        self.agreedTermsIds = agreedTermsIds
    }
}
