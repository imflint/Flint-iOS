//
//  ContentsUseCase.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

import Domain

protocol SearchContentsUseCaseFactory: SearchRepositoryFactory {
    func makeSearchContentsUseCase() -> SearchContentsUseCase
    func makeSearchContentsUseCase(searchRepository: SearchRepository) -> SearchContentsUseCase
}

extension SearchContentsUseCaseFactory {
    func makeSearchContentsUseCase() -> SearchContentsUseCase {
        return makeSearchContentsUseCase(searchRepository: makeSearchRepository())
    }
    func makeSearchContentsUseCase(searchRepository: SearchRepository) -> SearchContentsUseCase {
        return DefaultSearchContentsUseCase(searchRepository: searchRepository)
    }
}
