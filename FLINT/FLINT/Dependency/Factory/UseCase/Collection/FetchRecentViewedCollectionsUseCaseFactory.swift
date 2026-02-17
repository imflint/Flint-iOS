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
}

extension FetchRecentViewedCollectionsUseCaseFactory {
    func makeFetchRecentViewedCollectionsUseCase() -> FetchRecentViewedCollectionsUseCase {
        return DefaultFetchRecentViewedCollectionsUseCase(collectionRepository: makeCollectionRepository())
    }
}
