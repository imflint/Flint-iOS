//
//  File.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

import Domain

protocol ExploreUseCaseFactory: CollectionRepositoryFactory {
    func makeExploreUseCase() -> ExploreUseCase
    func makeExploreUseCase(collectionRepository: CollectionRepository) -> ExploreUseCase
}

extension ExploreUseCaseFactory {
    func makeExploreUseCase() -> ExploreUseCase {
        return makeExploreUseCase(collectionRepository: makeCollectionRepository())
    }
    func makeExploreUseCase(collectionRepository: CollectionRepository) -> ExploreUseCase {
        return DefaultExploreUseCase(collectionRepository: collectionRepository)
    }
}
