//
//  SavedContentItemViewModel.swift
//  FLINT
//
//  Created by 소은 on 1/15/26.
//

import UIKit

public struct SavedContentItemViewModel {

    public let posterImage: UIImage?
    public let title: String
    public let director: String
    public let year: String

    public init(
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
