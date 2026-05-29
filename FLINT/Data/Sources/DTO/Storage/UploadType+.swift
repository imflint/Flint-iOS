//
//  UploadType+.swift
//  Data
//
//  Created by 김호성 on 2026.05.01.
//

import Foundation

import Entity

extension UploadType {
    package var requestParameter: String {
        switch self {
        case .userProfile:
            return "USER_PROFILE"
        case .logoImage:
            return "LOGO_IMAGE"
        case .collectionThumbnail:
            return "COLLECTION_THUMBNAIL"
        case .collectionContent:
            return "COLLECTION_CONTENT"
        }
    }
}
