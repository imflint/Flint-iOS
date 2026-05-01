//
//  PresignedUrlInfoEntity.swift
//  Domain
//
//  Created by 김호성 on 2026.05.01.
//

import Foundation

public struct PresignedUrlInfoEntity {
    public let uploadUrl: URL
    public let key: String
    
    public init(uploadUrl: URL, key: String) {
        self.uploadUrl = uploadUrl
        self.key = key
    }
}
