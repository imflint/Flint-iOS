//
//  FetchRecommendedCollectionsUseCaseFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.09.
//

import Foundation

import Domain

protocol FetchRecommendedCollectionsUseCaseFactory: HomeRepositoryFactory {
    func makeFetchRecommendedCollectionsUseCase() -> FetchRecommendedCollectionsUseCase
    func makeFetchRecommendedCollectionsUseCase(homeRepository: HomeRepository) -> FetchRecommendedCollectionsUseCase
}

extension FetchRecommendedCollectionsUseCaseFactory {
    func makeFetchRecommendedCollectionsUseCase() -> FetchRecommendedCollectionsUseCase {
        return makeFetchRecommendedCollectionsUseCase(homeRepository: makeHomeRepository())
    }
    func makeFetchRecommendedCollectionsUseCase(homeRepository: HomeRepository) -> FetchRecommendedCollectionsUseCase {
        return DefaultFetchRecommendedCollectionsUseCase(homeRepository: homeRepository)
    }
}
