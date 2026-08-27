//
//  SplashViewModelFactory.swift
//  FLINT
//
//  Created by Hosung.Kim on 2026.08.23.
//

import Foundation

import Presentation

protocol SplashViewModelFactory: RefreshUseCaseFactory {
    func makeSplashViewModel() -> SplashViewModel
}

extension SplashViewModelFactory {
    func makeSplashViewModel() -> SplashViewModel {
        return DefaultSplashViewModel(refreshUseCase: makeRefreshUseCase())
    }
}
