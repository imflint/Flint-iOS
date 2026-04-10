//
//  FetchBookmarkedContentsUseCaseFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.09.
//

import Foundation

import Domain

protocol FetchBookmarkedContentsUseCaseFactory: ContentRepositoryFactory, UserRepositoryFactory {
    func makeFetchBookmarkedContentsUseCase() -> FetchBookmarkedContentsUseCase
}

extension FetchBookmarkedContentsUseCaseFactory {
    func makeFetchBookmarkedContentsUseCase() -> FetchBookmarkedContentsUseCase {
        return DefaultFetchBookmarkedContentsUseCase(contentRepository: makeContentRepository(), userRepository: makeUserRepository())
    }
}
