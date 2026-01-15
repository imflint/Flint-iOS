//
//  CollectonFolderView.swift
//  FLINT
//
//  Created by 소은 on 1/15/26.
//

import UIKit

extension CALayer {

    func applyShadow(
        color: UIColor = .black,
        alpha: Float,
        blur: CGFloat,
        spread: CGFloat = 0,
        x: CGFloat = 0,
        y: CGFloat = 0,
        cornerRadius: CGFloat = 0
    ) {
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2

        if spread == 0 {
            shadowPath = nil
            return
        }

        let dx = -spread
        let rect = bounds.insetBy(dx: dx, dy: dx)

        if cornerRadius > 0 {
            shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
        } else {
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
