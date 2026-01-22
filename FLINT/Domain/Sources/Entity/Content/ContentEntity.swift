//
//  File.swift
//  Domain
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

public struct ContentEntity {
    public let id: String
    public let title: String
    public let author: String
    public let posterUrl: URL?
    public let year: Int
    
    public init(id: String, title: String, author: String, posterUrl: URL?, year: Int) {
        self.id = id
        self.title = title
        self.author = author
        self.posterUrl = posterUrl
        self.year = year
    }
}
