//
//  UITextView+Typography.swift
//  FLINT
//
//  Created by 소은 on 1/4/26.
//

import UIKit

extension UITextView {

    func applyFontStyle(
        _ style: TypographyStyle,
        textColor: UIColor? = nil,
        alignment: NSTextAlignment = .natural
    ) {
        font = style.font
        if let textColor { self.textColor = textColor }

        let attrs = style.attributes(textColor: textColor, alignment: alignment)

        typingAttributes = attrs

        let current = text ?? ""
        attributedText = NSAttributedString(string: current, attributes: attrs)
    }
}
