//
//  FetchPopularCollectionsUseCaseFactory.swift
//  FLINT
//
//  Created by 소은 on 2026.06.08.
//

import Foundation

import Domain

protocol FetchPopularCollectionsUseCaseFactory: HomeRepositoryFactory {
    func makeFetchPopularCollectionsUseCase() -> FetchPopularCollectionsUseCase
}

extension FetchPopularCollectionsUseCaseFactory {
    func makeFetchPopularCollectionsUseCase() -> FetchPopularCollectionsUseCase {
        return DefaultFetchPopularCollectionsUseCase(homeRepository: makeHomeRepository())
    }
}
