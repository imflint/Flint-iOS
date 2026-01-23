//
//  CollectionDetailFactory.swift
//  FLINT
//
//  Created by 진소은 on 1/23/26.
//

import Foundation

import Moya

import Data
import Domain
import Presentation

protocol CollectionDetailFactory: CollectionRepositoryFactory {

    // MARK: - UseCase
    func makeCollectionDetailUseCase(collectionRepository: CollectionRepository) -> CollectionDetailUseCase
    func makeCollectionDetailUseCase() -> CollectionDetailUseCase

    // MARK: - ViewModel
    func makeCollectionDetailViewModel(collectionId: Int64) -> CollectionDetailViewModel
    func makeCollectionDetailViewModel(
        collectionId: Int64,
        collectionDetailUseCase: CollectionDetailUseCase
    ) -> CollectionDetailViewModel
}

extension CollectionDetailFactory {

    // MARK: - UseCase
    func makeCollectionDetailUseCase() -> CollectionDetailUseCase {
        return makeCollectionDetailUseCase(collectionRepository: makeCollectionRepository())
    }

    func makeCollectionDetailUseCase(collectionRepository: CollectionRepository) -> CollectionDetailUseCase {
        return DefaultCollectionDetailUseCase(collectionRepository: collectionRepository)
    }

    // MARK: - ViewModel
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
            collectionDetailUseCase: collectionDetailUseCase
        )
    }
}
