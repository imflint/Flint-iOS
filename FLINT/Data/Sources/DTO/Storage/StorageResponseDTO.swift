//
//  StorageResponseDTO.swift
//  Data
//
//  Created by 김호성 on 2026.05.01.
//

import Foundation

import Entity

public struct StorageResponseDTO: Decodable {
    package let uploadUrl: String?
    package let key: String?
}

extension StorageResponseDTO {
    package var presignedUrlInfoEntity: PresignedUrlInfoEntity {
        get throws {
            return try PresignedUrlInfoEntity(
                uploadUrl: unwrap(URL(string: uploadUrl ?? "")),
                key: unwrap(key)
            )
        }
    }
}
