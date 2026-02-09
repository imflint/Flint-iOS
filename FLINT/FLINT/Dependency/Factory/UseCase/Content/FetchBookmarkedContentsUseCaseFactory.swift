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
    func makeFetchBookmarkedContentsUseCase(contentRepository: ContentRepository, userRepository: UserRepository) -> FetchBookmarkedContentsUseCase
}

extension FetchBookmarkedContentsUseCaseFactory {
    func makeFetchBookmarkedContentsUseCase() -> FetchBookmarkedContentsUseCase {
        return makeFetchBookmarkedContentsUseCase(contentRepository: makeContentRepository(), userRepository: makeUserRepository())
    }
    func makeFetchBookmarkedContentsUseCase(contentRepository: ContentRepository, userRepository: UserRepository) -> FetchBookmarkedContentsUseCase {
        return DefaultFetchBookmarkedContentsUseCase(contentRepository: contentRepository, userRepository: userRepository)
    }
}
