//
//  FetchExploreCollectionsUseCaseFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

import Domain

protocol FetchExploreCollectionsUseCaseFactory: CollectionRepositoryFactory {
    func makeFetchCollectionsUseCase() -> FetchExploreCollectionsUseCase
    func makeFetchCollectionsUseCase(collectionRepository: CollectionRepository) -> FetchExploreCollectionsUseCase
}

extension FetchExploreCollectionsUseCaseFactory {
    func makeFetchCollectionsUseCase() -> FetchExploreCollectionsUseCase {
        return makeFetchCollectionsUseCase(collectionRepository: makeCollectionRepository())
    }
    func makeFetchCollectionsUseCase(collectionRepository: CollectionRepository) -> FetchExploreCollectionsUseCase {
        return DefaultFetchExploreCollectionsUseCase(collectionRepository: collectionRepository)
    }
}
