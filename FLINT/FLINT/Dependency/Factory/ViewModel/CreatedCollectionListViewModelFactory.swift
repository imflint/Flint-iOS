//
//  CreatedCollectionListViewModelFactory.swift
//  FLINT
//
//  Created by 진소은 on 8/20/26.
//

import Foundation

import Domain
import Presentation

protocol CreatedCollectionListViewModelFactory:
    FetchCreatedCollectionsUseCaseFactory &
    ToggleCollectionBookmarkUseCaseFactory {
    func makeCreatedCollectionListViewModel(target: UserTarget) -> CreatedCollectionListViewModel
}

extension CreatedCollectionListViewModelFactory {
    func makeCreatedCollectionListViewModel(target: UserTarget) -> CreatedCollectionListViewModel {
        return CreatedCollectionListViewModel(
            target: target,
            fetchCreatedCollectionsUseCase: makeFetchCreatedCollectionsUseCase(),
            toggleCollectionBookmarkUseCase: makeToggleCollectionBookmarkUseCase()
        )
    }
}
