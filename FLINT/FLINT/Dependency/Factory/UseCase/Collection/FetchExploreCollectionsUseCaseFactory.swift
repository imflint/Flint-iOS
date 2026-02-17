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
}

extension FetchExploreCollectionsUseCaseFactory {
    func makeFetchExploreCollectionsUseCase() -> FetchExploreCollectionsUseCase {
        return DefaultFetchExploreCollectionsUseCase(collectionRepository: makeCollectionRepository())
    }
}
