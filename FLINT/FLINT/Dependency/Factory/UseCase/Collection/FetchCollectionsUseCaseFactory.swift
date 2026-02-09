//
//  FetchCollectionsUseCaseFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

import Domain

protocol FetchCollectionsUseCaseFactory: CollectionRepositoryFactory {
    func makeFetchCollectionsUseCase() -> FetchCollectionsUseCase
    func makeFetchCollectionsUseCase(collectionRepository: CollectionRepository) -> FetchCollectionsUseCase
}

extension FetchCollectionsUseCaseFactory {
    func makeFetchCollectionsUseCase() -> FetchCollectionsUseCase {
        return makeFetchCollectionsUseCase(collectionRepository: makeCollectionRepository())
    }
    func makeFetchCollectionsUseCase(collectionRepository: CollectionRepository) -> FetchCollectionsUseCase {
        return DefaultFetchCollectionsUseCase(collectionRepository: collectionRepository)
    }
}
