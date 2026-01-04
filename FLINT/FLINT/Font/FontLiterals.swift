//
//  FontLiterals.swift
//  FLINT
//
//  Created by 소은 on 1/4/26.
//

import UIKit

// MARK: - FontName

enum FontName: String {
    case pretendardBold = "Pretendard-Bold"
    case pretendardSemiBold = "Pretendard-SemiBold"
    case pretendardMedium = "Pretendard-Medium"
    case pretendardRegular = "Pretendard-Regular"
}

// MARK: - UIFont Loader

extension UIFont {

    static func font(_ name: FontName, ofSize size: CGFloat) -> UIFont {
        guard let customFont = UIFont(name: name.rawValue, size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return customFont
    }
}
