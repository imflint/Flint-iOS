//
//  SplashViewControllerFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.30.
//

import Foundation

import Presentation

extension LoginViewControllerFactory where Self: LoginViewModelFactory & ViewControllerFactory {
    func makeLoginViewController() -> LoginViewController {
        return LoginViewController(loginViewModel: makeLoginViewModel(), viewControllerFactory: self)
    }
}
