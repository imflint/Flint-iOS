//
//  FetchOTTPlatformsDTO.swift
//  Data
//
//  Created by 소은 on 1/21/26.
//

import Foundation

import Entity

public struct FetchOTTPlatformsDTO: Codable {
    public let ottId: String?
    public let name: String?
    public let logoUrl: String?
    public let contentUrl: String?
}

extension FetchOTTPlatformsDTO {
    public var entity: FetchOTTPlatformsEntity.OTTPlatformEntity {
        return FetchOTTPlatformsEntity.OTTPlatformEntity(
            ottId: ottId ?? "",
            name: name ?? "",
            logoUrl: logoUrl ?? "",
            contentUrl: contentUrl ?? ""
        )
    }
}
