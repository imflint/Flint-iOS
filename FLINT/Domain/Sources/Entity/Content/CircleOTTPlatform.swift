//
//  CircleOTTPlatform.swift
//  Domain
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
}

extension Sequence where Element == CircleOTTPlatform {
    func sortedByOrder() -> [CircleOTTPlatform] {
        let rank = Dictionary(uniqueKeysWithValues: CircleOTTPlatform.order.enumerated().map { ($0.element, $0.offset) })
        return self.sorted { (rank[$0] ?? .max) < (rank[$1] ?? .max) }
    }
}

public extension CircleOTTPlatform {
    init?(serverName: String) {
        let trimmed = serverName.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalized = trimmed
            .uppercased()
            .replacingOccurrences(of: "-", with: "_")
            .replacingOccurrences(of: " ", with: "_")

        switch normalized {
        case "NETFLIX": self = .netflix
        case "TVING": self = .tving
        case "COUPANG_PLAY", "COUPANGPLAY": self = .coupangPlay
        case "WAVVE": self = .wavve
        case "DISNEY_PLUS", "DISNEYPLUS", "DISNEY": self = .disneyPlus
        case "WATCHA": self = .watcha
        default:
            switch trimmed {
            case "넷플릭스": self = .netflix
            case "티빙": self = .tving
            case "쿠팡플레이": self = .coupangPlay
            case "웨이브": self = .wavve
            case "디즈니+", "디즈니플러스": self = .disneyPlus
            case "왓차": self = .watcha
            default: return nil
            }
        }
    }
}
