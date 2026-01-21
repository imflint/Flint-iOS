//
//  NSAttributedString+.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.12.
//

import UIKit

extension NSAttributedString {
    public static func pretendard(
        _ style: UIFont.PretendardStyle,
        text: String,
        color: UIColor? = nil,
        lineBreakMode: NSLineBreakMode = .byTruncatingTail,
        lineBreakStrategy: NSParagraphStyle.LineBreakStrategy? = nil,
        alignment: NSTextAlignment = .natural,
    ) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.minimumLineHeight = style.lineHeight
        paragraph.maximumLineHeight = style.lineHeight
        paragraph.lineBreakMode = lineBreakMode
        paragraph.alignment = alignment
        if let lineBreakStrategy {
            paragraph.lineBreakStrategy = lineBreakStrategy
        }

        let baseline = (style.lineHeight - style.font.lineHeight) / 2

        var attributes: [NSAttributedString.Key: Any] = [
            .font: style.font,
            .paragraphStyle: paragraph,
            .baselineOffset: baseline,
            .kern: style.kern
        ]
        if let color {
            attributes[.foregroundColor] = color
        }
        return NSAttributedString(string: text, attributes: attributes)
    }
}
