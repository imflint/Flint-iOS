//
//  SessionEntity.swift
//  Domain
//
//  Created by Hosung.Kim on 2026.10.14.
//

import Foundation

public struct SessionEntity {
    public let items: [ExploreInfoEntity]
    public let state: String
    public let hasNext: Bool
    public let lastViewedPosition: Int
    public let canAdvance: Bool
    
    public init(items: [ExploreInfoEntity], state: String, hasNext: Bool, lastViewedPosition: Int, canAdvance: Bool) {
        self.items = items
        self.state = state
        self.hasNext = hasNext
        self.lastViewedPosition = lastViewedPosition
        self.canAdvance = canAdvance
    }
}
