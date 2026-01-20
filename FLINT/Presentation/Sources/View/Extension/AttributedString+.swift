//
//  AttributedString+.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.12.
//

import UIKit

extension AttributedString {
    public static func pretendard(
        _ style: UIFont.PretendardStyle,
        text: String,
        color: UIColor? = nil,
        lineBreakMode: NSLineBreakMode = .byTruncatingTail,
        lineBreakStrategy: NSParagraphStyle.LineBreakStrategy? = nil,
        alignment: NSTextAlignment = .natural,
    ) -> AttributedString {
        return AttributedString(
            NSAttributedString.pretendard(
                style,
                text: text,
                color: color,
                lineBreakMode: lineBreakMode,
                lineBreakStrategy: lineBreakStrategy,
                alignment: alignment
            )
        )
    }
}
