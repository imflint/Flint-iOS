//
//  CollectionDetailViewModel.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.02.
//

import Foundation

import Domain
import Presentation

protocol CollectionDetailViewModelFactory: CollectionDetailUseCaseFactory, FetchBookmarkedUserUseCaseFactory {
    func makeCollectionDetailViewModel(collectionId: Int64) -> CollectionDetailViewModel
    func makeCollectionDetailViewModel(
        collectionId: Int64,
        collectionDetailUseCase: CollectionDetailUseCase
    ) -> CollectionDetailViewModel
}

extension CollectionDetailViewModelFactory {
    func makeCollectionDetailViewModel(collectionId: Int64) -> CollectionDetailViewModel {
        return makeCollectionDetailViewModel(
            collectionId: collectionId,
            collectionDetailUseCase: makeCollectionDetailUseCase()
        )
    }
    func makeCollectionDetailViewModel(
        collectionId: Int64,
        collectionDetailUseCase: CollectionDetailUseCase
    ) -> CollectionDetailViewModel {
        return CollectionDetailViewModel(
            collectionId: collectionId,
            collectionDetailUseCase: collectionDetailUseCase,
            fetchBookmarkedUserUseCase: makeFetchBookmarkedUserUseCase()
        )
    }
}
