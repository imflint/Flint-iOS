//
//  SplashViewController.swift
//  Presentation
//
//  Created by 진소은 on 1/22/26.
//


import UIKit
import Combine

import View
import ViewModel

public final class SplashViewController: BaseViewController<SplashView> {

    public override func viewDidLoad() {
        super.viewDidLoad()

        rootView.onFinished = { [weak self] in
            self?.showLogin()
        }
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rootView.play()
    }

    private func showLogin() {
        let vc = LoginViewController() // 아래 참고
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
}
