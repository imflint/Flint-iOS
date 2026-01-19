//
//  ToastAppearance.swift
//  Toast
//
//  Created by Bastiaan Jansen on 29/06/2021.
//

import UIKit

protocol ToastView : UIView {
    func createView(for toast: Toast)
}
