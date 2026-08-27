//
//  CreatedCollectionListViewControllerFactory+.swift
//  FLINT
//
//  Created by 진소은 on 8/20/26.
//

import Foundation

import Domain
import Presentation

extension CreatedCollectionListViewControllerFactory where Self: CreatedCollectionListViewModelFactory & ViewControllerFactory {
    func makeCreatedCollectionListViewController(target: UserTarget) -> CreatedCollectionListViewController {
        return CreatedCollectionListViewController(
            viewModel: makeCreatedCollectionListViewModel(target: target),
            viewControllerFactory: self
        )
    }
}
