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
    public let color: KeywordColor
    public let rank: Int
    public let name: String
    public let percentage: Int
    public let imageUrl: String
    
    public init(color: KeywordColor, rank: Int, name: String, percentage: Int, imageUrl: String) {
        self.color = color
        self.rank = rank
        self.name = name
        self.percentage = percentage
        self.imageUrl = imageUrl
    }
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
