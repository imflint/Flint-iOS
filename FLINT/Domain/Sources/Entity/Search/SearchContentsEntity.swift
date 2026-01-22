//
//  SearchContentsEntity.swift
//  Domain
//
//  Created by 소은 on 1/20/26.
//

import Foundation

public struct SearchContentsEntity {
    
    public let contents: [SearchContent]
    
    public init(contents: [SearchContent]) {
        self.contents = contents
    }
}

public extension SearchContentsEntity {

    struct SearchContent: Identifiable {

        public let id: String
        public let title: String
        public let author: String
        public let posterUrl: String
        public let year: Int

        public init(
            id: String,
            title: String,
            author: String,
            posterUrl: String,
            year: Int
        ) {
            self.id = id
            self.title = title
            self.author = author
            self.posterUrl = posterUrl
            self.year = year
        }
    }
}
