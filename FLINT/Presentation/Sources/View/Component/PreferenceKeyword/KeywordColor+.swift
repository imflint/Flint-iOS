//
//  KeywordColor+.swift
//  FLINT
//
//  Created by 진소은 on 1/18/26.
//

import UIKit

import Domain

extension KeywordColor {
    public var tagBackgroundImage: UIImage {
        switch self {
        case .pink:   return UIImage(resource: .imgTagPink)
        case .green:  return UIImage(resource: .imgTagGreen)
        case .orange: return UIImage(resource: .imgTagOrange)
        case .yellow: return UIImage(resource: .imgTagYellow)
        case .blue:   return UIImage(resource: .imgTagBlue)
        }
    }
}
