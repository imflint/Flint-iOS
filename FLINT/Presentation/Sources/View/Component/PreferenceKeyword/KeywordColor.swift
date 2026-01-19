//
//  KeywordColor.swift
//  FLINT
//
//  Created by 진소은 on 1/18/26.
//

import Foundation
import UIKit

public enum KeywordColor: String, Decodable {
    case pink = "PINK"
    case green = "GREEN"
    case orange = "ORANGE"
    case yellow = "YELLOW"
    case blue = "BLUE"
}

public struct KeywordDTO: Decodable {
    let color: KeywordColor
    let rank: Int
    let name: String
    let percentage: Int
    let imageUrl: String
}

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
