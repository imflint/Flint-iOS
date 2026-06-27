//
//  SearchContentsUseCaseFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

import Domain

protocol SearchContentsUseCaseFactory: ContentRepositoryFactory {
    func makeSearchContentsUseCase() -> SearchContentsUseCase
}

extension SearchContentsUseCaseFactory {
    func makeSearchContentsUseCase() -> SearchContentsUseCase {
        return DefaultSearchContentsUseCase(contentRepository: makeContentRepository())
    }
}
