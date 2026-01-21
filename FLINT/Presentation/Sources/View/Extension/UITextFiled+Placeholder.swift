//
//  UITextFiled+Placeholder.swift
//  FLINT
//
//  Created by 진소은 on 1/6/26.
//

import UIKit

extension UITextField {
    
    public func setPlaceholder(color: UIColor) {
        guard let string = self.placeholder else {
            return
        }
        attributedPlaceholder = NSAttributedString(string: string, attributes: [.foregroundColor: color])
    }
}
