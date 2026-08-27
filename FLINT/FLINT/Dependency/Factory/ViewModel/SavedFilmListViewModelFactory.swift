//
//  SavedFilmListViewModelFactory.swift
//  FLINT
//
//  Created by 진소은 on 8/20/26.
//

import Foundation

import Presentation

protocol SavedFilmListViewModelFactory:
    FetchBookmarkedContentsPageUseCaseFactory &
    FetchBookmarkedContentCountUseCaseFactory &
    ToggleContentBookmarkUseCaseFactory {
    func makeSavedFilmListViewModel() -> SavedFilmListViewModel
}

extension SavedFilmListViewModelFactory {
    func makeSavedFilmListViewModel() -> SavedFilmListViewModel {
        return SavedFilmListViewModel(
            fetchBookmarkedContentsPageUseCase: makeFetchBookmarkedContentsPageUseCase(),
            fetchBookmarkedContentCountUseCase: makeFetchBookmarkedContentCountUseCase(),
            toggleContentBookmarkUseCase: makeToggleContentBookmarkUseCase()
        )
    }
}
