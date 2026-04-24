//
//  ToggleBookmarkResponseDTO.swift
//  Data
//
//  Created by 소은 on 4/22/26.
//


import Foundation

import Entity

public struct ToggleBookmarkResponseDTO: Codable {
    public let data: Bool?
}

extension ToggleBookmarkResponseDTO {
    public var entity: Bool {
        return data ?? false
    }
}
