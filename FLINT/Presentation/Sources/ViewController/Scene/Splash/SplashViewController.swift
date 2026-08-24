//
//  SplashViewController.swift
//  Presentation
//
//  Created by 진소은 on 1/22/26.
//

import Combine
import UIKit

import View
import ViewModel

public protocol SplashViewControllerFactory {
    func makeSplashViewController() -> SplashViewController
}

public final class SplashViewController: BaseViewController<SplashView> {
    
    private let splashViewModel: SplashViewModel
    
    public init(splashViewModel: SplashViewModel, viewControllerFactory: ViewControllerFactory) {
        self.splashViewModel = splashViewModel
        super.init(viewControllerFactory: viewControllerFactory)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView.onFinished = { [weak self] in
            self?.splashViewModel.refresh()
        }
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rootView.play()
    }
    
    public override func bind() {
        splashViewModel.route.sink { [weak self] splashRoute in
            switch splashRoute {
            case .home:
                self?.showHome()
            case .login:
                self?.showLogin()
            }
        }
        .store(in: &cancellables)
    }
    
    private func showHome() {
        guard let tabBarViewController = viewControllerFactory?.makeTabBarViewController() else { return }
        navigationController?.setViewControllers([tabBarViewController], animated: false)
    }
    
    private func showLogin() {
        guard let loginViewController = viewControllerFactory?.makeLoginViewController() else { return }
        navigationController?.setViewControllers([loginViewController], animated: false)
    }
}
