//
//  FetchRecentViewedCollectionsUseCaseFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.09.
//

import Foundation

import Domain

protocol FetchRecentViewedCollectionsUseCaseFactory: CollectionRepositoryFactory {
    func makeFetchRecentViewedCollectionsUseCase() -> FetchRecentViewedCollectionsUseCase
    func makeFetchRecentViewedCollectionsUseCase(collectionRepository: CollectionRepository) -> FetchRecentViewedCollectionsUseCase
}

extension FetchRecentViewedCollectionsUseCaseFactory {
    func makeFetchRecentViewedCollectionsUseCase() -> FetchRecentViewedCollectionsUseCase {
        return makeFetchRecentViewedCollectionsUseCase(collectionRepository: makeCollectionRepository())
    }
    func makeFetchRecentViewedCollectionsUseCase(collectionRepository: CollectionRepository) -> FetchRecentViewedCollectionsUseCase {
        return DefaultFetchRecentViewedCollectionsUseCase(collectionRepository: collectionRepository)
    }
}
