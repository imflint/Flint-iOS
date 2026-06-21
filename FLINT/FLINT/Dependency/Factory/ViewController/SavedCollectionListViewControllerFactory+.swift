//
//  SavedCollectionListViewControllerFactory+.swift
//  FLINT
//
//  Created by 진소은 on 2026/06/19.
//

import Foundation

import Presentation

extension SavedCollectionListViewControllerFactory where Self: SavedCollectionListViewModelFactory & ViewControllerFactory {
    func makeSavedCollectionListViewController() -> SavedCollectionListViewController {
        return SavedCollectionListViewController(
            viewModel: makeSavedCollectionListViewModel(),
            viewControllerFactory: self
        )
    }
}
