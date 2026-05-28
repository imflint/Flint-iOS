//
//  SelectedContentReasonTableViewCellItem.swift
//  FLINT
//
//  Created by 소은 on 1/17/26.
//

import UIKit

public struct SelectedContentReasonTableViewCellItem {
    public var contentId: Int64
    public var posterURL: URL?
    public var posterImage: UIImage?
    public let title: String
    public let director: String
    public let year: String

    public var isSpoiler: Bool
    public var reasonText: String?
    public var photos: [UIImage]

    public init(
        contentId: Int64,
        posterURL: URL? = nil,
        posterImage: UIImage? = nil,
        title: String,
        director: String,
        year: String,
        isSpoiler: Bool = false,
        reasonText: String? = nil,
        photos: [UIImage] = []
    ) {
        self.contentId = contentId
        self.posterURL = posterURL
        self.posterImage = posterImage
        self.title = title
        self.director = director
        self.year = year
        self.isSpoiler = isSpoiler
        self.reasonText = reasonText
        self.photos = photos
    }
}

#if DEBUG
extension SelectedContentReasonTableViewCellItem {
    @MainActor static let mock = SelectedContentReasonTableViewCellItem(
        contentId: 0,
        posterURL: nil,
        posterImage: .imgTving,
        title: "영화이름 어어어어어엄 청길게 ",
        director: "감독이름도 어어어엄청 긴이름",
        year: "2016",
        isSpoiler: false,
        reasonText: ""
    )
}
#endif
