//
//  CollectionFolderListViewModelFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.02.
//

import Foundation

import Presentation

protocol CollectionFolderListViewModelFactory:
    FetchPopularCollectionsUseCaseFactory &
    ToggleCollectionBookmarkUseCaseFactory {
    func makeCollectionFolderListViewModel() -> CollectionFolderListViewModel
}

extension CollectionFolderListViewModelFactory {
    func makeCollectionFolderListViewModel() -> CollectionFolderListViewModel {
        return CollectionFolderListViewModel(
            fetchPopularCollectionsUseCase: makeFetchPopularCollectionsUseCase(),  
            toggleCollectionBookmarkUseCase: makeToggleCollectionBookmarkUseCase()
        )
    }
}
