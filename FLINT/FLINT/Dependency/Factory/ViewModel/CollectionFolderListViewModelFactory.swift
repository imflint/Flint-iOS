//
//  CollectionFolderListViewModelFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.02.
//

import Foundation

import Domain
import Presentation

protocol CollectionFolderListViewModelFactory: FetchRecentViewedCollectionsUseCaseFactory {
    func makeCollectionFolderListViewModel() -> CollectionFolderListViewModel
    func makeCollectionFolderListViewModel(fetchRecentViewedCollectionsUseCase: FetchRecentViewedCollectionsUseCase) -> CollectionFolderListViewModel
}

extension CollectionFolderListViewModelFactory {
    func makeCollectionFolderListViewModel() -> CollectionFolderListViewModel {
        return makeCollectionFolderListViewModel(fetchRecentViewedCollectionsUseCase: makeFetchRecentViewedCollectionsUseCase())
    }
    func makeCollectionFolderListViewModel(fetchRecentViewedCollectionsUseCase: FetchRecentViewedCollectionsUseCase) -> CollectionFolderListViewModel {
        return CollectionFolderListViewModel(fetchRecentViewedCollectionsUseCase: fetchRecentViewedCollectionsUseCase)
    }
}
