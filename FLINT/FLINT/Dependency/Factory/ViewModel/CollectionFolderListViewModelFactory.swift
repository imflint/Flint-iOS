//
//  CollectionFolderListViewModelFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.02.
//

import Foundation

import Domain
import Presentation

protocol CollectionFolderListViewModelFactory: FetchWatchingCollectionsUseCaseFactory {
    func makeCollectionFolderListViewModel() -> CollectionFolderListViewModel
    func makeCollectionFolderListViewModel(fetchWatchingCollectionsUseCase: FetchWatchingCollectionsUseCase) -> CollectionFolderListViewModel
}

extension CollectionFolderListViewModelFactory {
    func makeCollectionFolderListViewModel() -> CollectionFolderListViewModel {
        return makeCollectionFolderListViewModel(fetchWatchingCollectionsUseCase: makeFetchWatchingCollectionsUseCase())
    }
    func makeCollectionFolderListViewModel(fetchWatchingCollectionsUseCase: FetchWatchingCollectionsUseCase) -> CollectionFolderListViewModel {
        return CollectionFolderListViewModel(fetchWatchingCollectionsUseCase: fetchWatchingCollectionsUseCase)
    }
}
