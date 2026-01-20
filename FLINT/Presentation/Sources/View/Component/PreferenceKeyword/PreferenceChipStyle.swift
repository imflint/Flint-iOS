//
//  PreferenceChipStyle.swift
//  FLINT
//
//  Created by 진소은 on 1/18/26.
//

import Foundation
import UIKit

public enum PreferenceChipStyle {
    case colored(KeywordColor)
    case gray

    public var height: CGFloat {
        switch self {
        case .colored: return 50
        case .gray:    return 34
        }
    }

    public var hInset: CGFloat {
        switch self {
        case .colored: return 28
        case .gray:    return 20
        }
    }

    public var vInset: CGFloat {
        switch self {
        case .colored: return 12
        case .gray:    return 8
        }
    }

    public var iconSize: CGFloat {
        switch self {
        case .colored: return 20
        case .gray:    return 0
        }
    }

    public var spacing: CGFloat {
        switch self {
        case .colored: return 12
        case .gray:    return 0
        }
    }

    public func backgroundImage(for color: KeywordColor) -> UIImage {
        switch self {
        case .colored:
            return color.tagBackgroundImage
        case .gray:
            return UIImage(resource: .tagGray)
        }
    }

    public static func from(rank: Int, color: KeywordColor) -> PreferenceChipStyle {
        if (4...6).contains(rank) { return .gray }
        return .colored(color)
    }
}
