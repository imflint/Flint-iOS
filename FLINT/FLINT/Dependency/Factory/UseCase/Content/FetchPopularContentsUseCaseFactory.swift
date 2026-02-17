//
//  FetchPopularContentsUseCaseFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.09.
//

import Foundation

import Domain

protocol FetchPopularContentsUseCaseFactory: SearchRepositoryFactory {
    func makeFetchPopularContentsUseCase() -> FetchPopularContentsUseCase
}

extension FetchPopularContentsUseCaseFactory {
    func makeFetchPopularContentsUseCase() -> FetchPopularContentsUseCase {
        return DefaultFetchPopularContentsUseCase(searchRepository: makeSearchRepository())
    }
}
