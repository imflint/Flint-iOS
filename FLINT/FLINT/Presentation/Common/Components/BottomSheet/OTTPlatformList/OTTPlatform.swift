//
//  OTTPlatform.swift
//  FLINT
//
//  Created by 소은 on 1/12/26.
//

import UIKit

enum OTTPlatform: String, CaseIterable, Hashable {

    case netflix = "NETFLIX"
    case tving = "TVING"
    case wave = "WAVVE"
    case coupangPlay = "COUPANG_PLAY"
    case watcha = "WATCHA"
    case disneyPlus = "DISNEY_PLUS"

    var title: String {
        switch self {
        case .netflix: return "넷플릭스"
        case .tving: return "티빙"
        case .wave: return "웨이브"
        case .coupangPlay: return "쿠팡플레이"
        case .watcha: return "왓차"
        case .disneyPlus: return "디즈니+"
        }
    }

    var icon: UIImage? {
        switch self {
        case .netflix: return UIImage.imgNetflix
        case .tving: return UIImage.imgTving
        case .wave: return UIImage.imgWave
        case .coupangPlay: return UIImage.imgCoupang
        case .watcha: return UIImage.imgWatcha
        case .disneyPlus: return UIImage.imgDisney
        }
    }

    // MARK: - URL

    //TODO: 서버 연동 시 서버 값으로 대체
    var webURL: URL {
        let urlString: String = {
            switch self {
            case .netflix: return "https://www.netflix.com"
            case .tving: return "https://www.tving.com"
            case .wave: return "https://www.wavve.com"
            case .coupangPlay: return "https://www.coupangplay.com"
            case .watcha: return "https://watcha.com"
            case .disneyPlus: return "https://www.disneyplus.com"
            }
        }()
        return URL(string: urlString) ?? URL(string: "https://www.google.com")!
    }
}
