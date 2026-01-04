//
//  UIButton+Typography.swift
//  FLINT
//
//  Created by 소은 on 1/4/26.
//

import UIKit

extension UIButton {

    func applyFontStyle(
        _ style: TypographyStyle,
        for state: UIControl.State = .normal,
        textColor: UIColor? = nil,
        alignment: NSTextAlignment = .center
    ) {
        let color = textColor ?? titleColor(for: state)
        let attrs = style.attributes(textColor: color, alignment: alignment)
        let title = title(for: state) ?? ""
        setAttributedTitle(NSAttributedString(string: title, attributes: attrs), for: state)
    }

    func setTitle(
        _ title: String,
        style: TypographyStyle,
        for state: UIControl.State = .normal,
        textColor: UIColor? = nil,
        alignment: NSTextAlignment = .center
    ) {
        let color = textColor ?? titleColor(for: state)
        let attrs = style.attributes(textColor: color, alignment: alignment)
        setAttributedTitle(NSAttributedString(string: title, attributes: attrs), for: state)
    }
}
