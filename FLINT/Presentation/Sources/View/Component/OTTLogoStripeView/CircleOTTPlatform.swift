//
//  CircleOTTPlatform.swift
//  FLINT
//
//  Created by 소은 on 1/13/26.
//

import UIKit

public enum CircleOTTPlatform: CaseIterable, Hashable, Sendable {
    case netflix
    case tving
    case coupangPlay
    case wavve
    case disneyPlus
    case watcha
    
    public static let order: [CircleOTTPlatform] = [
        .netflix, .tving, .coupangPlay, .wavve, .disneyPlus, .watcha
    ]
    
    public var smallLogoImage: UIImage? {
        switch self {
        case .netflix:     return UIImage.imgSmallNetflix1
        case .tving:       return UIImage.imgSmallTving1
        case .coupangPlay: return UIImage.imgSmallCoupang1
        case .wavve:        return UIImage.imgSmallWavve1
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

public extension CircleOTTPlatform {
    init?(serverName: String) {
        let key = serverName
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        switch key {
        case "netflix": self = .netflix
        case "tving": self = .tving
        case "coupangplay": self = .coupangPlay
        case "wavve": self = .wavve
        case "disney": self = .disneyPlus
        case "watcha": self = .watcha
        default: return nil
        }
    }
}
