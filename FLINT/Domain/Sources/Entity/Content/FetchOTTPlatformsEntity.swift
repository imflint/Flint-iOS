//
//  FetchOTTEntity.swift
//  Domain
//
//  Created by 소은 on 1/21/26.
//

import Foundation

public struct FetchOTTPlatformsEntity {
    
    public let ottPlatforms: [OTTPlatformEntity]
    
    public init(ottPlatforms: [OTTPlatformEntity]) {
        self.ottPlatforms = ottPlatforms
    }
}

public extension FetchOTTPlatformsEntity {
    
    struct OTTPlatformEntity {
        
        public let ottId: Int
        public let name: String
        public let logoUrl: String
        public let contentUrl: String
        
        public init(ottId: Int,
                    name: String,
                    logoUrl: String,
                    contentUrl: String
        ) {
            self.ottId = ottId
            self.name = name
            self.logoUrl = logoUrl
            self.contentUrl = contentUrl
        }
    }
}
