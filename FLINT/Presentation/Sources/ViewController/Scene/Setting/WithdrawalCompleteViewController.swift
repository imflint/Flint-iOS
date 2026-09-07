//
//  WithdrawalCompleteViewController.swift
//  FLINT
//
//  Created by 진소은 on 9/6/26.
//

import UIKit

import View
import ViewModel

public protocol WithdrawalCompleteViewControllerFactory {
    func makeWithdrawalCompleteViewController() -> WithdrawalCompleteViewController
}

public final class WithdrawalCompleteViewController: BaseViewController<WithdrawalCompleteView> {

    public override init(viewControllerFactory: (any ViewControllerFactory)?) {
        super.init(viewControllerFactory: viewControllerFactory)
    }

    required init?(coder: NSCoder) { fatalError() }

    public override func viewDidLoad() {
        super.viewDidLoad()
        statusBarBackgroundView.isHidden = true
        navigationBarView.isHidden = true
        setupActions()
    }

    public override func setUI() {
        view.backgroundColor = DesignSystem.Color.background
    }

    private func setupActions() {
        rootView.goHomeButton.addAction(UIAction { [weak self] _ in
            self?.transitionToLogin()
        }, for: .touchUpInside)
    }

    private func transitionToLogin() {
        guard let factory = viewControllerFactory,
              let window = view.window else { return }

        let loginVC = factory.makeLoginViewController()
        let nav = UINavigationController(rootViewController: loginVC)
        nav.modalPresentationStyle = .fullScreen

        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
            window.rootViewController = nav
        }
    }
}
