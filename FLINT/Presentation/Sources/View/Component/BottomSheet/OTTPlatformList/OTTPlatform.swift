//
//  OTTPlatform.swift
//  FLINT
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

    public var icon: UIImage? {
        switch self {
        case .netflix: return UIImage.imgSmallNetflix1
        case .tving: return UIImage.imgSmallTving1
        case .wavve: return UIImage.imgSmallWavve1
        case .coupangPlay: return UIImage.imgSmallCoupang1
        case .watcha: return UIImage.imgSmallWatcha1
        case .disneyPlus: return UIImage.imgSmallDisney1
        }
    }

    // MARK: - URL

    //TODO: 서버 연동 시 서버 값으로 대체
    public var webURL: URL {
        let urlString: String = {
            switch self {
            case .netflix: return "https://www.netflix.com"
            case .tving: return "https://www.tving.com"
            case .wavve: return "https://www.wavve.com"
            case .coupangPlay: return "https://www.coupangplay.com"
            case .watcha: return "https://watcha.com"
            case .disneyPlus: return "https://www.disneyplus.com"
            }
        }()
        return URL(string: urlString) ?? URL(string: "https://www.google.com")!
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
        // 서버가 "NETFLIX" 같은 raw value로 내려주는 경우
        if let p = OTTPlatform(rawValue: name) { return p }

        // 혹시 서버가 소문자/다른 케이스면 보정
        return OTTPlatform(rawValue: name.uppercased())
    }
}
