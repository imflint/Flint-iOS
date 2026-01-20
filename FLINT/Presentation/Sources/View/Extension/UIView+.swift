//
//  UIView+.swift
//  FLINT
//
//  Created by 진소은 on 1/5/26.
//

import UIKit

extension UIView {
    public func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
}
