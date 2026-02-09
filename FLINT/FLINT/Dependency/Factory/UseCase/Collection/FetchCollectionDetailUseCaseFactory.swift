//
//  FetchCollectionDetailUseCaseFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.02.
//

import Foundation

import Domain

protocol FetchCollectionDetailUseCaseFactory: CollectionRepositoryFactory {
    func makeFetchCollectionDetailUseCase() -> FetchCollectionDetailUseCase
    func makeFetchCollectionDetailUseCase(collectionRepository: CollectionRepository) -> FetchCollectionDetailUseCase
}

extension FetchCollectionDetailUseCaseFactory {
    func makeFetchCollectionDetailUseCase() -> FetchCollectionDetailUseCase {
        return makeFetchCollectionDetailUseCase(collectionRepository: makeCollectionRepository())
    }
    func makeFetchCollectionDetailUseCase(collectionRepository: CollectionRepository) -> FetchCollectionDetailUseCase {
        return DefaultFetchCollectionDetailUseCase(collectionRepository: collectionRepository)
    }
}
