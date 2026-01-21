//
//  SavedContentItem.swift
//  FLINT
//
//  Created by 소은 on 1/15/26.
//

import UIKit

public struct SavedContentItemViewModel {
    
    public let contentId: Int64
    public let posterImage: UIImage?
    public let title: String
    public let director: String
    public let year: String

    public init(
        contentId: Int64,
        posterImage: UIImage?,
        title: String,
        director: String,
        year: String
    ) {
        self.contentId = contentId
        self.posterImage = posterImage
        self.title = title
        self.director = director
        self.year = year
    }
}
