//
//  BaseViewController+NavigationBar.swift
//  FLINT
//
//  Created by 진소은 on 1/14/26.
//

import UIKit

import SnapKit

extension BaseViewController {
    func installNavigationBarIfNeeded() {
        navigationController?.setNavigationBarHidden(true, animated: false)

        if navigationBarView.superview != nil { return }

        view.addSubview(navigationBarView)
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(56)
        }

        navigationBarView.onTapLeft = { [weak self] in
            guard let self else { return }
            if let nav = self.navigationController, nav.viewControllers.count > 1 {
                nav.popViewController(animated: true)
            } else {
                self.dismiss(animated: true)
            }
        }

        navigationBarView.onTapRight = { [weak self] in
            guard let self else { return }
            self.dismiss(animated: true)
        }
    }

    func setNavigationBar(_ config: NavigationBarConfig,
                          onTapLeft: (() -> Void)? = nil,
                          onTapRight: (() -> Void)? = nil) {
        installNavigationBarIfNeeded()
        navigationBarView.apply(config)
        if let onTapLeft { navigationBarView.onTapLeft = onTapLeft }
        if let onTapRight { navigationBarView.onTapRight = onTapRight }
    }
}
