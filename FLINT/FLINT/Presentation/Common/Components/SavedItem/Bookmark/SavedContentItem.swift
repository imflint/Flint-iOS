//
//  SavedContentItem.swift
//  FLINT
//
//  Created by 소은 on 1/15/26.
//

import UIKit

struct SavedContentItemViewModel {

    let posterImage: UIImage?
    let title: String
    let director: String
    let year: String
    let isOTTDisplayEligible: Bool

    let isBookmarked: Bool
    let bookmarkCount: Int?
    let leadingPlatforms: [CircleOTTPlatform]?
    let remainingPlatformCount: Int?

    init(
        posterImage: UIImage?,
        title: String,
        director: String,
        year: String,
        isOTTDisplayEligible: Bool = true,
        isBookmarked: Bool = false,
        bookmarkCount: Int? = nil,
        leadingPlatforms: [CircleOTTPlatform]? = nil,
        remainingPlatformCount: Int? = nil
    ) {
        self.posterImage = posterImage
        self.title = title
        self.director = director
        self.year = year
        self.isOTTDisplayEligible = isOTTDisplayEligible
        self.isBookmarked = isBookmarked
        self.bookmarkCount = bookmarkCount
        self.leadingPlatforms = leadingPlatforms
        self.remainingPlatformCount = remainingPlatformCount
    }
}
