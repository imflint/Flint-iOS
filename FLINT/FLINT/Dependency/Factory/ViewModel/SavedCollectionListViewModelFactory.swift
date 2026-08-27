//
//  SavedCollectionListViewModelFactory.swift
//  FLINT
//
//  Created by 진소은 on 2026/06/19.
//

import Foundation

import Domain
import Presentation

protocol SavedCollectionListViewModelFactory:
    FetchBookmarkedCollectionsUseCaseFactory &
    ToggleCollectionBookmarkUseCaseFactory {
    func makeSavedCollectionListViewModel(target: UserTarget) -> SavedCollectionListViewModel
}

extension SavedCollectionListViewModelFactory {
    func makeSavedCollectionListViewModel(target: UserTarget) -> SavedCollectionListViewModel {
        return SavedCollectionListViewModel(
            target: target,
            fetchBookmarkedCollectionsUseCase: makeFetchBookmarkedCollectionsUseCase(),
            toggleCollectionBookmarkUseCase: makeToggleCollectionBookmarkUseCase()
        )
    }
}
