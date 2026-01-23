//
//  Ott.swift
//  Presentation
//
//  Created by 김호성 on 2026.01.23.
//

import UIKit

import Domain

extension Ott {
    public var logo: UIImage {
        switch self {
        case .netflix:
            return DesignSystem.Image.Logo.netflix
        case .tving:
            return DesignSystem.Image.Logo.tving
        case .coupangPlay:
            return DesignSystem.Image.Logo.coupang
        case .wavve:
            return DesignSystem.Image.Logo.wavve
        case .disneyPlus:
            return DesignSystem.Image.Logo.disney
        case .watchapedia:
            return DesignSystem.Image.Logo.watcha
        }
    }
    
    public var smallLogo: UIImage {
        switch self {
        case .netflix:
            return DesignSystem.Image.Logo.netflixSmall
        case .tving:
            return DesignSystem.Image.Logo.tvingSmall
        case .coupangPlay:
            return DesignSystem.Image.Logo.coupangSmall
        case .wavve:
            return DesignSystem.Image.Logo.wavveSmall
        case .disneyPlus:
            return DesignSystem.Image.Logo.disneySmall
        case .watchapedia:
            return DesignSystem.Image.Logo.watchaSmall
        }
    }
}
