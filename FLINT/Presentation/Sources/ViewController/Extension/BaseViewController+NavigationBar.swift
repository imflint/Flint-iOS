//
//  BaseViewController+NavigationBar.swift
//  FLINT
//
//  Created by 진소은 on 1/14/26.
//

import UIKit

import SnapKit

import View

extension BaseViewController {

    public func setNavigationBar(_ config: NavigationBarConfig,
                          onTapLeft: (() -> Void)? = nil,
                          onTapRight: (() -> Void)? = nil) {
        statusBarBackgroundView.isHidden = false
        navigationBarView.isHidden = false
        navigationBarView.apply(config)
        updateStatusBarBackgroundColor(backgroundStyle: config.backgroundStyle)
        navigationBarView.onTapLeft = onTapLeft ?? defaultLeftNavigationAction
        navigationBarView.onTapRight = onTapRight ?? defaultRightNavigationAction
    }
    
    private func updateStatusBarBackgroundColor(backgroundStyle: NavigationBarBackgroundStyle) {
        switch backgroundStyle {
        case .solid(let color):
            statusBarBackgroundView.backgroundColor = color
        case .clear:
            statusBarBackgroundView.backgroundColor = .clear
        }
    }
    
    private func defaultLeftNavigationAction() {
        if let nav = navigationController, nav.viewControllers.count > 1 {
            nav.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
    private func defaultRightNavigationAction() {
        dismiss(animated: true)
    }
}
