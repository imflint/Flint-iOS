//
//  UITextField+Typography.swift
//  FLINT
//
//  Created by 소은 on 1/4/26.
//

import UIKit

extension UITextField {

    func applyFontStyle(
        _ style: TypographyStyle,
        textColor: UIColor? = nil,
        alignment: NSTextAlignment = .natural
    ) {
        font = style.font

        if let textColor { self.textColor = textColor }

        let attrs = style.attributes(textColor: textColor, alignment: alignment)
        defaultTextAttributes = attrs

        if let t = text, !t.isEmpty {
            attributedText = NSAttributedString(string: t, attributes: attrs)
        }
    }
    
    func applyPlaceholderFontStyle(
        _ style: TypographyStyle,
        textColor: UIColor? = nil,
        alignment: NSTextAlignment = .natural
    ) {
        guard let placeholder else { return }
        var attrs = style.attributes(textColor: textColor, alignment: alignment)
        attrs[.foregroundColor] = textColor
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attrs)
    }
}
