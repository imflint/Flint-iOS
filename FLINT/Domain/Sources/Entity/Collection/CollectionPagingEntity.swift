//
//  File.swift
//  Domain
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

public struct CollectionPagingEntity {
    public let collections: [CollectionInfoEntity]
    public let cursor: UInt
    
    public init(collections: [CollectionInfoEntity], cursor: UInt) {
        self.collections = collections
        self.cursor = cursor
    }
}
