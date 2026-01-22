//
//  FetchOTTPlatformsDTO.swift
//  Data
//
//  Created by 소은 on 1/21/26.
//

import Foundation

import Entity

public struct OTTPlatformsDTO: Codable {
    public let otts: [OTTPlatformDTO]?
}

extension OTTPlatformsDTO {
    public struct OTTPlatformDTO: Codable {
        public let ottId: String?
        public let name: String?
        public let logoUrl: String?
        public let contentUrl: String?
    }
}

extension OTTPlatformsDTO {
    public var entity: [OTTPlatformEntity] {
        get throws {
            return try otts?.map({ try $0.entity }) ?? []
        }
    }
}

extension OTTPlatformsDTO.OTTPlatformDTO {
    public var entity: OTTPlatformEntity {
        get throws {
            return try OTTPlatformEntity(
                ottId: unwrap(ottId, key: CodingKeys.ottId),
                name: name ?? "",
                logoUrl: logoUrl ?? "",
                contentUrl: contentUrl ?? ""
            )
        }
    }
}
