//
//  UIColor+.swift
//  Flint
//
//  Created by 김호성 on 2025.11.07.
//

import UIKit

extension UIColor {
    public convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255.0,
            green: CGFloat((hex >> 8) & 0xFF) / 255.0,
            blue: CGFloat(hex & 0xFF) / 255.0,
            alpha: alpha
        )
    }
}
