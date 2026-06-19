//
//  LogoutRequestDTO.swift
//  Data
//
//  Created by 소은 on 6/19/26.
//

import Foundation

public struct LogoutRequestDTO: Encodable {
    public let refreshToken: String
    
    public init(refreshToken: String) {
        self.refreshToken = refreshToken
    }
}
