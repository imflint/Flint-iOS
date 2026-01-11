//
//  NSMutableAttributedString+.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.12.
//

import UIKit

extension NSMutableAttributedString {
    func applyPretendardFont(_ style: UIFont.PretendardStyle, range: NSRange) {
        addAttributes([.font: UIFont.pretendard(style)], range: range)
    }
}
