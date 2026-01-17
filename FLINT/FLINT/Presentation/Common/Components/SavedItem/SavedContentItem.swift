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

    init(
        posterImage: UIImage?,
        title: String,
        director: String,
        year: String
    ) {
        self.posterImage = posterImage
        self.title = title
        self.director = director
        self.year = year
    }
}
