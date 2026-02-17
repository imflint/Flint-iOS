//
//  CollectionDetailViewModelFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.02.
//

import Foundation

import Presentation

protocol CollectionDetailViewModelFactory: FetchCollectionDetailUseCaseFactory, FetchCollectionBookmarkUsersUseCaseFactory {
    func makeCollectionDetailViewModel(collectionId: Int64) -> CollectionDetailViewModel
}

extension CollectionDetailViewModelFactory {
    func makeCollectionDetailViewModel(collectionId: Int64) -> CollectionDetailViewModel {
        return CollectionDetailViewModel(collectionId: collectionId, fetchCollectionDetailUseCase: makeFetchCollectionDetailUseCase(), fetchCollectionBookmarkUsersUseCase: makeFetchCollectionBookmarkUsersUseCase())
    }
}
