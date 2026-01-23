//
//  KeywordEntity.swift
//  Domain
//
//  Created by 진소은 on 1/22/26.
//

import Foundation

public struct KeywordEntity {
    public let color: String
    public let rank: Int
    public let name: String
    public let percentage: Int
    public let imageUrl: String

    public init(color: String, rank: Int, name: String, percentage: Int, imageUrl: String) {
        self.color = color
        self.rank = rank
        self.name = name
        self.percentage = percentage
        self.imageUrl = imageUrl
    }
}
