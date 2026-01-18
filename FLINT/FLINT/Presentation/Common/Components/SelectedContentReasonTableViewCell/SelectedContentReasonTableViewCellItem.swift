//
//  SelectedContentReasonTableViewCellItem.swift
//  FLINT
//
//  Created by 소은 on 1/17/26.
//

import UIKit

struct SelectedContentReasonTableViewCellItem {
    let posterImage: UIImage?
    let title: String
    let director: String
    let year: String

    var isSpoiler: Bool
    var reasonText: String?

    init(
        posterImage: UIImage? = nil,
        title: String,
        director: String,
        year: String,
        isSpoiler: Bool = false,
        reasonText: String? = nil
    ) {
        self.posterImage = posterImage
        self.title = title
        self.director = director
        self.year = year
        self.isSpoiler = isSpoiler
        self.reasonText = reasonText
    }
}
