//
//  SavedUserRowItem.swift
//  FLINT
//
//  Created by 소은 on 1/12/26.
//

import UIKit

public struct SavedUserRowItem: Hashable {
    public let userId: String
    public let profileImageURL: URL?
    public let nickname: String
    public let isVerified: Bool

    public init(userId: String, profileImageURL: URL?, nickname: String, isVerified: Bool) {
        self.userId = userId
        self.profileImageURL = profileImageURL
        self.nickname = nickname
        self.isVerified = isVerified
    }
}
