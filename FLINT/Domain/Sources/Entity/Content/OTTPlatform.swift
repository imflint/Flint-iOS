//
//  OTTPlatform.swift
//  Domain
//
//  Created by 소은 on 1/12/26.
//

import UIKit

public enum OTTPlatform: String, CaseIterable, Hashable {

    case netflix = "NETFLIX"
    case tving = "TVING"
    case wavve = "WAVVE"
    case coupangPlay = "COUPANG_PLAY"
    case watcha = "WATCHA"
    case disneyPlus = "DISNEY_PLUS"

    public var title: String {
        switch self {
        case .netflix: return "넷플릭스"
        case .tving: return "티빙"
        case .wavve: return "웨이브"
        case .coupangPlay: return "쿠팡플레이"
        case .watcha: return "왓차"
        case .disneyPlus: return "디즈니+"
        }
    }
}

extension OTTPlatform {
    public init(circle: CircleOTTPlatform) {
        switch circle {
        case .netflix: self = .netflix
        case .tving: self = .tving
        case .wavve: self = .wavve
        case .watcha: self = .watcha
        case .disneyPlus: self = .disneyPlus
        case .coupangPlay: self = .coupangPlay
        }
    }
}

extension OTTPlatform {
    public static func fromServerName(_ name: String) -> OTTPlatform? {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let upper = trimmed.uppercased()

        if let p = OTTPlatform(rawValue: upper) { return p }

        let normalized = upper
            .replacingOccurrences(of: "-", with: "_")
            .replacingOccurrences(of: " ", with: "_")

        if let p = OTTPlatform(rawValue: normalized) { return p }

        if normalized == "COUPANGPLAY" { return .coupangPlay }

        switch trimmed {
        case "쿠팡플레이": return .coupangPlay
        case "넷플릭스": return .netflix
        case "티빙": return .tving
        case "웨이브": return .wavve
        case "왓차": return .watcha
        case "디즈니+", "디즈니플러스": return .disneyPlus
        default: return nil
        }
    }
}
