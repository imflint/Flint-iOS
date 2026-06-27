//
//  HomeViewControllerFactory+.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.31.
//

import Foundation

import Presentation

extension HomeViewControllerFactory where Self: HomeViewModelFactory & FetchOTTPlatformsForContentUseCaseFactory & ViewControllerFactory {
    func makeHomeViewController() -> HomeViewController {
        return HomeViewController(
            viewModel: makeHomeViewModel(),
            fetchOTTPlatformsForContentUseCase: makeFetchOTTPlatformsForContentUseCase(),
            viewControllerFactory: self
        )
    }
}
