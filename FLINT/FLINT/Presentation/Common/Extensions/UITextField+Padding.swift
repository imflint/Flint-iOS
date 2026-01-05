//
//  UITextField+Padding.swift
//  FLINT
//
//  Created by 진소은 on 1/5/26.
//

import UIKit

extension UITextField {
    
    func setPlaceholder(color: UIColor) {
        guard let string = self.placeholder else {
            return
        }
        attributedPlaceholder = NSAttributedString(string: string, attributes: [.foregroundColor: color])
    }
    
    func addPadding(_ width: CGFloat = 10) {
        addLeftPadding(width)
        addRightPadding(width)
    }
    
    func addLeftPadding(_ width: CGFloat = 10) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    func addRightPadding(_ width: CGFloat = 10) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
        self.rightView = paddingView
        self.rightViewMode = ViewMode.always
    }
    
}
