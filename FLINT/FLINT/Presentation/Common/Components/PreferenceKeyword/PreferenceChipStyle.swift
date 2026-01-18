//
//  PreferenceChipStyle.swift
//  FLINT
//
//  Created by 진소은 on 1/18/26.
//

import Foundation
import UIKit

enum PreferenceChipStyle {
    case colored(KeywordColor)
    case gray

    var height: CGFloat {
        switch self {
        case .colored: return 50
        case .gray:    return 34
        }
    }

    var hInset: CGFloat {
        switch self {
        case .colored: return 28
        case .gray:    return 20
        }
    }

    var vInset: CGFloat {
        switch self {
        case .colored: return 12
        case .gray:    return 8
        }
    }

    var iconSize: CGFloat {
        switch self {
        case .colored: return 20
        case .gray:    return 0
        }
    }

    var spacing: CGFloat {
        switch self {
        case .colored: return 12
        case .gray:    return 0
        }
    }

    func backgroundImage(for color: KeywordColor) -> UIImage {
        switch self {
        case .colored:
            return color.tagBackgroundImage
        case .gray:
            return UIImage(resource: .tagGray)
        }
    }

    static func from(rank: Int, color: KeywordColor) -> PreferenceChipStyle {
        if (4...6).contains(rank) { return .gray }
        return .colored(color)
    }
}
