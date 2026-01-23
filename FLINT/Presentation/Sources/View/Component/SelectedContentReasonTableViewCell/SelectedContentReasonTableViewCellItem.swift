//
//  SelectedContentReasonTableViewCellItem.swift
//  FLINT
//
//  Created by 소은 on 1/17/26.
//

import UIKit

public struct SelectedContentReasonTableViewCellItem {
    public var posterURL: URL?
    public var posterImage: UIImage?
    public let title: String
    public let director: String
    public let year: String

    public var isSpoiler: Bool
    public var reasonText: String?

    public init(
        posterURL: URL? = nil,
        posterImage: UIImage? = nil,
        title: String,
        director: String,
        year: String,
        isSpoiler: Bool = false,
        reasonText: String? = nil
    ) {
        self.posterURL = posterURL
        self.posterImage = posterImage
        self.title = title
        self.director = director
        self.year = year
        self.isSpoiler = isSpoiler
        self.reasonText = reasonText
    }
}
