//
//  CollectionFolderListViewControllerFactory+.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.31.
//

import Foundation

import Presentation

extension CollectionFolderListViewControllerFactory where Self: HomeFactory & ViewControllerFactory {
    func makeCollectionFolderListViewController() -> CollectionFolderListViewController {
        let vm = CollectionFolderListViewModel(fetchWatchingCollectionsUseCase: makeFetchWatchingCollectionsUseCase())
        return CollectionFolderListViewController(viewModel: vm, viewControllerFactory: self)
    }
}
