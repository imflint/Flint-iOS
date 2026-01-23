//
//  Ott.swift
//  Presentation
//
//  Created by 김호성 on 2026.01.23.
//

public enum Ott: Int, CaseIterable {
    case netflix
    case tving
    case coupangPlay
    case wavve
    case disneyPlus
    case watchapedia
    
    public var korTitle: String {
        switch self {
        case .netflix:
            return "넷플릭스"
        case .tving:
            return "티빙"
        case .coupangPlay:
            return "쿠팡플레이"
        case .wavve:
            return "웨이브"
        case .disneyPlus:
            return "디즈니플러스"
        case .watchapedia:
            return "왓챠피디아"
        }
    }
    
    public var id: Int {
        return rawValue+1
    }
}
