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
    
    public init(viewControllerFactory: ViewControllerFactory) {
        super.init(nibName: nil, bundle: nil)
        self.viewControllerFactory = viewControllerFactory
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        guard let loginViewController = viewControllerFactory?.makeLoginViewController() else { return }
        navigationController?.setViewControllers([loginViewController], animated: false)
    }
}
