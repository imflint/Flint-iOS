//
//  KeywordEntity.swift
//  Domain
//
//  Created by 진소은 on 1/22/26.
//

import Foundation

public struct KeywordEntity {
    public let color: KeywordColor
    public let rank: Int
    public let name: String
    public let percentage: Int
    public let imageUrl: URL?

    public init(color: KeywordColor, rank: Int, name: String, percentage: Int, imageUrl: URL?) {
        self.color = color
        self.rank = rank
        self.name = name
        self.percentage = percentage
        self.imageUrl = imageUrl
    }
}
