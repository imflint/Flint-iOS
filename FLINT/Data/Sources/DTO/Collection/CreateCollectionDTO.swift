//
//  CreateCollectionDTO.swift
//  DTO
//
//  Created by 소은 on 1/23/26.
//

import Foundation

public struct CreateCollectionDTO: Codable {
    public let collectionId: String?
}

extension CreateCollectionDTO {
    public var createdCollectionId: Int64 {
        get throws {
            return try unwrap(Int64(collectionId ?? ""))
        }
    }
}
