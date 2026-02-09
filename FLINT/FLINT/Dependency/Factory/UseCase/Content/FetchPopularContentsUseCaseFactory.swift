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
    func makeFetchPopularContentsUseCase(searchRepository: SearchRepository) -> FetchPopularContentsUseCase
}

extension FetchPopularContentsUseCaseFactory {
    func makeFetchPopularContentsUseCase() -> FetchPopularContentsUseCase {
        return makeFetchPopularContentsUseCase(searchRepository: makeSearchRepository())
    }
    func makeFetchPopularContentsUseCase(searchRepository: SearchRepository) -> FetchPopularContentsUseCase {
        return DefaultFetchPopularContentsUseCase(searchRepository: searchRepository)
    }
}
