//
//  ExploreViewControllerFactory+.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.31.
//

import Foundation

import Presentation

extension ExploreViewControllerFactory where Self: ExploreViewModelFactory & ViewControllerFactory {
    func makeExploreViewController() -> ExploreViewController {
        return ExploreViewController(exploreViewModel: makeExploreViewModel(), viewControllerFactory: self)
    }
}
