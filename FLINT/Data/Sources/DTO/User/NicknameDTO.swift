//
//  File.swift
//  Data
//
//  Created by Hosung.Kim on 2026.08.24.
//

import Foundation

public struct NicknameDTO: Codable {
    let nickname: String
    
    package init(nickname: String) {
        self.nickname = nickname
    }
}
