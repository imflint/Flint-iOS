//
//  UIStackView+.swift
//  FLINT
//
//  Created by 진소은 on 1/5/26.
//

import UIKit

extension UIStackView {
    
    public func addArrangedSubviews(_ views: UIView...) {
        views.forEach { self.addArrangedSubview($0) }
    }
}
