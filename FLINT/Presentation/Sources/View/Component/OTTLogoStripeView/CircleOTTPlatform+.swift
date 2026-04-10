//
//  CircleOTTPlatform+.swift
//  Domain
//
//  Created by 소은 on 1/13/26.
//

import UIKit

import Domain

extension CircleOTTPlatform {
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
