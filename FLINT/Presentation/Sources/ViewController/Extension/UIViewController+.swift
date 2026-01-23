//
//  UIViewController+.swift
//  Flint
//
//  Created by 김호성 on 2025.10.23.
//

import UIKit

extension UIViewController: @retroactive UIGestureRecognizerDelegate {
    public func hideKeyboardWhenTappedAround(activeOnAction: Bool = true) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        if !activeOnAction {
            tap.delegate = self
        }
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !(touch.view is UIControl)
    }
}
