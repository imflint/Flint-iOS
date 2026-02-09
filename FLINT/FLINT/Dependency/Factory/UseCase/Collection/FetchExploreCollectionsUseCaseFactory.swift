//
//  FetchExploreCollectionsUseCaseFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

import Domain

protocol FetchExploreCollectionsUseCaseFactory: CollectionRepositoryFactory {
    func makeFetchExploreCollectionsUseCase() -> FetchExploreCollectionsUseCase
    func makeFetchExploreCollectionsUseCase(collectionRepository: CollectionRepository) -> FetchExploreCollectionsUseCase
}

extension FetchExploreCollectionsUseCaseFactory {
    func makeFetchExploreCollectionsUseCase() -> FetchExploreCollectionsUseCase {
        return makeFetchExploreCollectionsUseCase(collectionRepository: makeCollectionRepository())
    }
    func makeFetchExploreCollectionsUseCase(collectionRepository: CollectionRepository) -> FetchExploreCollectionsUseCase {
        return DefaultFetchExploreCollectionsUseCase(collectionRepository: collectionRepository)
    }
}
