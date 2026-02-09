//
//  CollectionDetailViewModel.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.02.
//

import Foundation

import Domain
import Presentation

protocol CollectionDetailViewModelFactory: FetchCollectionDetailUseCaseFactory, FetchCollectionBookmarkUsersUseCaseFactory {
    func makeCollectionDetailViewModel(collectionId: Int64) -> CollectionDetailViewModel
    func makeCollectionDetailViewModel(
        collectionId: Int64,
        fetchCollectionDetailUseCase: FetchCollectionDetailUseCase,
        fetchCollectionBookmarkUsersUseCase: FetchCollectionBookmarkUsersUseCase
    ) -> CollectionDetailViewModel
}

extension CollectionDetailViewModelFactory {
    func makeCollectionDetailViewModel(collectionId: Int64) -> CollectionDetailViewModel {
        return makeCollectionDetailViewModel(
            collectionId: collectionId,
            fetchCollectionDetailUseCase: makeFetchCollectionDetailUseCase(),
            fetchCollectionBookmarkUsersUseCase: makeFetchCollectionBookmarkUsersUseCase()
        )
    }
    func makeCollectionDetailViewModel(
        collectionId: Int64,
        fetchCollectionDetailUseCase: FetchCollectionDetailUseCase,
        fetchCollectionBookmarkUsersUseCase: FetchCollectionBookmarkUsersUseCase
    ) -> CollectionDetailViewModel {
        return CollectionDetailViewModel(
            collectionId: collectionId,
            fetchCollectionDetailUseCase: fetchCollectionDetailUseCase,
            fetchCollectionBookmarkUsersUseCase: fetchCollectionBookmarkUsersUseCase
        )
    }
}
