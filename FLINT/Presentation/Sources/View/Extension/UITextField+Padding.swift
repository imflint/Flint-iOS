//
//  UITextField+Padding.swift
//  FLINT
//
//  Created by 진소은 on 1/5/26.
//

import UIKit

extension UITextField {
    
    public func addPadding(_ width: CGFloat = 12) {
        addLeftPadding(width)
        addRightPadding(width)
    }
    
    public func addLeftPadding(_ width: CGFloat = 12) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    public func addRightPadding(_ width: CGFloat = 12) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        self.rightView = paddingView
        self.rightViewMode = ViewMode.always
    }
}
