//
//  SavedCollectionListViewModelFactory.swift
//  FLINT
//
//  Created by 진소은 on 2026/06/19.
//

import Foundation

import Presentation

protocol SavedCollectionListViewModelFactory:
    FetchBookmarkedCollectionsUseCaseFactory &
    ToggleCollectionBookmarkUseCaseFactory {
    func makeSavedCollectionListViewModel() -> SavedCollectionListViewModel
}

extension SavedCollectionListViewModelFactory {
    func makeSavedCollectionListViewModel() -> SavedCollectionListViewModel {
        return SavedCollectionListViewModel(
            fetchBookmarkedCollectionsUseCase: makeFetchBookmarkedCollectionsUseCase(),
            toggleCollectionBookmarkUseCase: makeToggleCollectionBookmarkUseCase()
        )
    }
}
