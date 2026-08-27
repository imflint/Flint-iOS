//
//  SplashViewControllerFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.30.
//

import Foundation

import Presentation

extension SplashViewControllerFactory where Self: SplashViewModelFactory & ViewControllerFactory {
    func makeSplashViewController() -> SplashViewController {
        return SplashViewController(splashViewModel: makeSplashViewModel(), viewControllerFactory: self)
    }
}
