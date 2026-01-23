//
//  File.swift
//  Domain
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

public struct CollectionPagingEntity {
    public let collections: [ExploreInfoEntity]
    public let cursor: UInt
    
    public init(collections: [ExploreInfoEntity], cursor: UInt) {
        self.collections = collections
        self.cursor = cursor
    }
}
