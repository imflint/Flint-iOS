//
//  SavedUserRowItem.swift
//  FLINT
//
//  Created by 소은 on 1/12/26.
//

import UIKit

public struct SavedUserRowItem: Hashable {
    let id: UUID
    let profileImage: UIImage?
    let nickname: String
    let isVerified: Bool
}
