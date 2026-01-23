//
//  ContentEntity.swift
//  Domain
//
//  Created by 진소은 on 1/23/26.
//

import Foundation

public struct ContentInfoEntity: Equatable {
    public let id: String
    public let title: String
    public let imageUrl: String
    public let year: Int
    public let ottList: [OttSimpleEntity]

    public init(
        id: String,
        title: String,
        imageUrl: String,
        year: Int,
        ottList: [OttSimpleEntity]
    ) {
        self.id = id
        self.title = title
        self.imageUrl = imageUrl
        self.year = year
        self.ottList = ottList
    }
}

public struct OttSimpleEntity: Equatable {
    public let ottName: String
    public let logoUrl: String

    public init(
        ottName: String,
        logoUrl: String
    ) {
        self.ottName = ottName
        self.logoUrl = logoUrl
    }
}
