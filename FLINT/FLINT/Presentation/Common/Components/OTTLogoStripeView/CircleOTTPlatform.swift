//
//  CircleOTTPlatform.swift
//  FLINT
//
//  Created by 소은 on 1/13/26.
//

import UIKit

enum CircleOTTPlatform: CaseIterable, Hashable {
    case netflix
    case tving
    case coupangPlay
    case wave
    case disneyPlus
    case watcha
    
    static let order: [CircleOTTPlatform] = [
        .netflix, .tving, .coupangPlay, .wave, .disneyPlus, .watcha
    ]
    
    var smallLogoImage: UIImage? {
        switch self {
        case .netflix:     return UIImage.imgSmallNetflix1
        case .tving:       return UIImage.imgSmallTving1
        case .coupangPlay: return UIImage.imgSmallCoupang1
        case .wave:        return UIImage.imgSmallWave1
        case .disneyPlus:  return UIImage.imgSmallDisney1
        case .watcha:      return UIImage.imgSmallWatcha1
        }
    }
}

extension Sequence where Element == CircleOTTPlatform {
    func sortedByOrder() -> [CircleOTTPlatform] {
        let rank = Dictionary(uniqueKeysWithValues: CircleOTTPlatform.order.enumerated().map { ($0.element, $0.offset) })
        return self.sorted { (rank[$0] ?? .max) < (rank[$1] ?? .max) }
    }
}
