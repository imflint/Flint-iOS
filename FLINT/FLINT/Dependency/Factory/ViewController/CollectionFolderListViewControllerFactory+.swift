//
//  CollectionFolderListViewControllerFactory+.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.31.
//

import Foundation

import Presentation

extension CollectionFolderListViewControllerFactory where Self: CollectionFolderListViewModelFactory & ViewControllerFactory {
    func makeCollectionFolderListViewController() -> CollectionFolderListViewController {
        return CollectionFolderListViewController(viewModel: makeCollectionFolderListViewModel(), viewControllerFactory: self)
    }
}
