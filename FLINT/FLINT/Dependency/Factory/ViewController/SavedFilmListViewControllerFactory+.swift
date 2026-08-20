//
//  SavedFilmListViewControllerFactory+.swift
//  FLINT
//
//  Created by 진소은 on 8/20/26.
//

import Foundation

import Presentation

extension SavedFilmListViewControllerFactory where Self: SavedFilmListViewModelFactory & ViewControllerFactory {
    func makeSavedFilmListViewController() -> SavedFilmListViewController {
        return SavedFilmListViewController(
            viewModel: makeSavedFilmListViewModel(),
            viewControllerFactory: self
        )
    }
}
