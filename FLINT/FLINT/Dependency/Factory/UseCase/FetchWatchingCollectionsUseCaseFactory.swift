//
//  FetchWatchingCollectionsUseCaseFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.02.
//

import Foundation

import Domain

protocol FetchWatchingCollectionsUseCaseFactory: CollectionRepositoryFactory {
    func makeFetchWatchingCollectionsUseCase() -> FetchWatchingCollectionsUseCase
    func makeFetchWatchingCollectionsUseCase(collectionRepository: CollectionRepository) -> FetchWatchingCollectionsUseCase
}

extension FetchWatchingCollectionsUseCaseFactory {
    func makeFetchWatchingCollectionsUseCase() -> FetchWatchingCollectionsUseCase {
        return makeFetchWatchingCollectionsUseCase(collectionRepository: makeCollectionRepository())
    }
    func makeFetchWatchingCollectionsUseCase(collectionRepository: CollectionRepository) -> FetchWatchingCollectionsUseCase {
        return DefaultFetchWatchingCollectionsUseCase(collectionRepository: collectionRepository)
    }
}
