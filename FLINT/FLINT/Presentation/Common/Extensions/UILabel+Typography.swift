//
//  UILabel+Typography.swift
//  FLINT
//
//  Created by 소은 on 1/4/26.
//

import UIKit

extension UILabel {
    
    func applyFontStyle(
        _ style: TypographyStyle,
        textColor: UIColor? = nil,
        alignment: NSTextAlignment = .natural
    ) {
        let attrs = style.attributes(textColor: textColor, alignment: alignment)
        let string = text ?? ""
        attributedText = NSAttributedString(string: string, attributes: attrs)
    }
}
