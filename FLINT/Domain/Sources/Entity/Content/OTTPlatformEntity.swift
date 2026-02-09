//
//  FetchOTTEntity.swift
//  Domain
//
//  Created by 소은 on 1/21/26.
//

import Foundation

public struct OTTPlatformEntity {
    public let ottId: String
    public let name: String
    public let logoUrl: URL?
    public let contentUrl: URL?
    
    public init(ottId: String, name: String, logoUrl: URL?, contentUrl: URL?) {
        self.ottId = ottId
        self.name = name
        self.logoUrl = logoUrl
        self.contentUrl = contentUrl
    }
}
