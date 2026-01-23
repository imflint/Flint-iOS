//
//  File.swift
//  Domain
//
//  Created by 김호성 on 2026.01.21.
//

import Foundation

public struct SignupInfoEntity: Codable {
    public let nickname: String
    public let favoriteContentIds: [Int] // Java Long
    public let subscribedOttIds: [Int] // Java Long
    
    public init(nickname: String, favoriteContentIds: [Int], subscribedOttIds: [Int]) {
        self.nickname = nickname
        self.favoriteContentIds = favoriteContentIds
        self.subscribedOttIds = subscribedOttIds
    }
}
