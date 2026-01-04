//
//  TypographyStyle.swift
//  FLINT
//
//  Created by 소은 on 1/4/26.
//

import UIKit

// MARK: - Typography Token

enum TypographyStyle {

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
}

// MARK: - lineHeight, kern 조정

private struct TypographySpec {
    let font: UIFont
    let lineHeight: CGFloat
    let kern: CGFloat

    var baselineOffset: CGFloat {
        (lineHeight - font.lineHeight) / 2
    }

    func paragraphStyle(alignment: NSTextAlignment) -> NSMutableParagraphStyle {
        let p = NSMutableParagraphStyle()
        p.minimumLineHeight = lineHeight
        p.maximumLineHeight = lineHeight
        p.alignment = alignment
        return p
    }
}

// MARK: - TypographyStyle 매핑

extension TypographyStyle {

    private var spec: TypographySpec {
        switch self {

        case .display1_sb_32:
            return .init(
                font: .font(.pretendardSemiBold, ofSize: 32),
                lineHeight: 32 * 1.50,
                kern: 32 * (-0.03)
            )

        case .display1_m_32:
            return .init(
                font: .font(.pretendardMedium, ofSize: 32),
                lineHeight: 32 * 1.50,
                kern: 32 * (-0.03)
            )

        case .display2_m_28:
            return .init(
                font: .font(.pretendardMedium, ofSize: 28),
                lineHeight: 28 * 1.50,
                kern: 28 * (-0.03)
            )

        case .head1_sb_22:
            return .init(
                font: .font(.pretendardSemiBold, ofSize: 22),
                lineHeight: 22 * 1.30,
                kern: 22 * (-0.03)
            )

        case .head1_m_22:
            return .init(
                font: .font(.pretendardMedium, ofSize: 22),
                lineHeight: 22 * 1.30,
                kern: 22 * (-0.03)
            )

        case .head2_sb_20:
            return .init(
                font: .font(.pretendardSemiBold, ofSize: 20),
                lineHeight: 20 * 1.30,
                kern: 20 * (-0.03)
            )

        case .head2_m_20:
            return .init(
                font: .font(.pretendardMedium, ofSize: 20),
                lineHeight: 20 * 1.30,
                kern: 20 * (-0.03)
            )

        case .head3_sb_18:
            return .init(
                font: .font(.pretendardSemiBold, ofSize: 18),
                lineHeight: 18 * 1.30,
                kern: 18 * (-0.03)
            )

        case .head3_m_18:
            return .init(
                font: .font(.pretendardMedium, ofSize: 18),
                lineHeight: 18 * 1.30,
                kern: 18 * (-0.03)
            )

        case .body1_b_16:
            return .init(
                font: .font(.pretendardBold, ofSize: 16),
                lineHeight: 16 * 1.40,
                kern: 16 * (-0.03)
            )

        case .body1_sb_16:
            return .init(
                font: .font(.pretendardSemiBold, ofSize: 16),
                lineHeight: 16 * 1.40,
                kern: 16 * (-0.03)
            )

        case .body1_m_16:
            return .init(
                font: .font(.pretendardMedium, ofSize: 16),
                lineHeight: 16 * 1.40,
                kern: 16 * (-0.03)
            )

        case .body1_r_16:
            return .init(
                font: .font(.pretendardRegular, ofSize: 16),
                lineHeight: 16 * 1.40,
                kern: 16 * (-0.03)
            )

        case .body2_m_14:
            return .init(
                font: .font(.pretendardMedium, ofSize: 14),
                lineHeight: 14 * 1.30,
                kern: 14 * (-0.03)
            )

        case .body2_r_14:
            return .init(
                font: .font(.pretendardRegular, ofSize: 14),
                lineHeight: 14 * 1.30,
                kern: 14 * (-0.03)
            )

        case .caption1_m_12:
            return .init(
                font: .font(.pretendardMedium, ofSize: 12),
                lineHeight: 12 * 1.30,
                kern: 12 * (-0.03)
            )
            
        case .caption1_r_12:
            return .init(
                font: .font(.pretendardRegular, ofSize: 12),
                lineHeight: 12 * 1.30,
                kern: 12 * (-0.03)
            )
            
        case .micro1_m_10:
            return .init(
                font: .font(.pretendardMedium, ofSize: 10),
                lineHeight: 10 * 1.30,
                kern: 10 * (-0.03)
            )
        }
    }
    
    var font: UIFont { spec.font }
    var lineHeight: CGFloat { spec.lineHeight }
    var kern: CGFloat { spec.kern }
    var baselineOffset: CGFloat { spec.baselineOffset }
    
    
    func attributes(
        textColor: UIColor?,
        alignment: NSTextAlignment
    ) -> [NSAttributedString.Key: Any] {
        
        var attrs: [NSAttributedString.Key: Any] = [
            .font: spec.font,
            .kern: spec.kern,
            .paragraphStyle: spec.paragraphStyle(alignment: alignment),
            .baselineOffset: spec.baselineOffset
        ]
        
        if let textColor { attrs[.foregroundColor] = textColor }
        return attrs
    }
}





