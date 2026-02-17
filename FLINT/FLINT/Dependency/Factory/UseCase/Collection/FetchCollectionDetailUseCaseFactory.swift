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
}

extension FetchCollectionDetailUseCaseFactory {
    func makeFetchCollectionDetailUseCase() -> FetchCollectionDetailUseCase {
        return DefaultFetchCollectionDetailUseCase(collectionRepository: makeCollectionRepository())
    }
}
