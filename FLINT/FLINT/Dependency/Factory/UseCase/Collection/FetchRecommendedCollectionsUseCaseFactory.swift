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
}

extension FetchRecommendedCollectionsUseCaseFactory {
    func makeFetchRecommendedCollectionsUseCase() -> FetchRecommendedCollectionsUseCase {
        return DefaultFetchRecommendedCollectionsUseCase(homeRepository: makeHomeRepository())
    }
}
