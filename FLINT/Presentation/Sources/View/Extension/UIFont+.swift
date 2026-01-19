//
//  UIFont+.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.12.
//

import UIKit

import Domain

extension UIFont {
    
    public enum PretendardWeight: String {
        case bold       = "Bold"
        case semiBold   = "SemiBold"
        case medium     = "Medium"
        case regular    = "Regular"
        
        public var name: String {
            return "Pretendard-\(rawValue)"
        }
    }
    
    public static func pretendard(_ weight: PretendardWeight, size fontSize: CGFloat) -> UIFont {
        if let font = UIFont(name: weight.name, size: fontSize) {
            return font
        }
        Log.e("Pretendard-\(weight.name) loading failed, fallback to system font")
        return .systemFont(ofSize: fontSize)
    }
    
    public enum PretendardStyle {
        case display1_sb_32
        case display1_m_32
        case display2_m_28
        
        case head1_sb_22
        case head1_m_22
        case head2_sb_20
        case head2_m_20
        case head3_sb_18
        case head3_m_18
        
        case body1_b_16
        case body1_sb_16
        case body1_m_16
        case body1_r_16
        case body2_m_14
        case body2_r_14
        
        case caption1_m_12
        case caption1_r_12
        
        case micro1_m_10
        
        public var size: CGFloat {
            switch self {
            case .display1_sb_32, .display1_m_32:
                return 32
            case .display2_m_28:
                return 28
            case .head1_sb_22, .head1_m_22:
                return 22
            case .head2_sb_20, .head2_m_20:
                return 20
            case .head3_sb_18, .head3_m_18:
                return 18
            case .body1_b_16, .body1_sb_16, .body1_m_16, .body1_r_16:
                return 16
            case .body2_m_14, .body2_r_14:
                return 14
            case .caption1_m_12, .caption1_r_12:
                return 12
            case .micro1_m_10:
                return 10
            }
        }
        
        public var font: UIFont {
            switch self {
            case .body1_r_16, .body2_r_14, .caption1_r_12:
                return .pretendard(.regular, size: size)
            case .display1_m_32, .display2_m_28, .head1_m_22, .head2_m_20, .head3_m_18, .body1_m_16, .body2_m_14, .caption1_m_12, .micro1_m_10:
                return .pretendard(.medium, size: size)
            case .display1_sb_32, .head1_sb_22, .head2_sb_20, .head3_sb_18, .body1_sb_16:
                return .pretendard(.semiBold, size: size)
            case .body1_b_16:
                return .pretendard(.bold, size: size)
            }
        }
        
        public var lineHeight: CGFloat {
            switch self {
            case .display1_sb_32, .display1_m_32, .display2_m_28:
                return size * 1.5
            case .body1_b_16, .body1_sb_16, .body1_m_16, .body1_r_16:
                return size * 1.4
            case .head1_sb_22, .head1_m_22, .head2_sb_20, .head2_m_20, .head3_sb_18, .head3_m_18, .body2_m_14, .body2_r_14, .caption1_m_12, .caption1_r_12, .micro1_m_10:
                return size * 1.3
            }
        }
        
        public var kern: CGFloat {
            return size * -0.03
        }
    }
    
    public static func pretendard(_ style: PretendardStyle) -> UIFont? {
        return style.font
    }
}
