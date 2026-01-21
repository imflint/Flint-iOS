//
//  BookmarkContentsListEntity.swift
//  Domain
//
//  Created by 소은 on 1/21/26.
//

import Foundation

public struct BookmarkContentsListEntity {

    public let contents: [BookmarkContentEntity]

    public init(contents: [BookmarkContentEntity]) {
        self.contents = contents
    }
}

public extension BookmarkContentsListEntity {

    struct BookmarkContentEntity {

        public let id: Int
        public let title: String
        public let year: Int
        public let ottList: [OTTSimpleEntity]

        public init(
            id: Int,
            title: String,
            year: Int,
            ottList: [OTTSimpleEntity]
        ) {
            self.id = id
            self.title = title
            self.year = year
            self.ottList = ottList
        }
    }

    struct OTTSimpleEntity {

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
}
