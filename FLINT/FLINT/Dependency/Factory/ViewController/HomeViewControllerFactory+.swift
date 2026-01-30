//
//  HomeViewControllerFactory+.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.31.
//

import Foundation

import Presentation

extension HomeViewControllerFactory where Self: HomeFactory & ViewControllerFactory {
    func makeHomeViewController() -> HomeViewController {
        return HomeViewController(viewModel: makeHomeViewModel(), viewControllerFactory: self)
    }
}
