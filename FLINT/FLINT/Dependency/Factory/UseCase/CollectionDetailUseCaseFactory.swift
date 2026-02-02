//
//  CollectionDetailUseCaseFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.02.
//

import Foundation

import Domain

protocol CollectionDetailUseCaseFactory: CollectionRepositoryFactory {
    func makeCollectionDetailUseCase(collectionRepository: CollectionRepository) -> CollectionDetailUseCase
    func makeCollectionDetailUseCase() -> CollectionDetailUseCase
}

extension CollectionDetailUseCaseFactory {
    func makeCollectionDetailUseCase() -> CollectionDetailUseCase {
        return makeCollectionDetailUseCase(collectionRepository: makeCollectionRepository())
    }
    func makeCollectionDetailUseCase(collectionRepository: CollectionRepository) -> CollectionDetailUseCase {
        return DefaultCollectionDetailUseCase(collectionRepository: collectionRepository)
    }
}
