//
//  FetchBookmarkedCollectionsUseCaseFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.09.
//

import Foundation

import Domain

protocol FetchBookmarkedCollectionsUseCaseFactory: UserRepositoryFactory {
    func makeFetchBookmarkedCollectionsUseCase() -> FetchBookmarkedCollectionsUseCase
    func makeFetchBookmarkedCollectionsUseCase(userRepository: UserRepository) -> FetchBookmarkedCollectionsUseCase
}

extension FetchBookmarkedCollectionsUseCaseFactory {
    func makeFetchBookmarkedCollectionsUseCase() -> FetchBookmarkedCollectionsUseCase {
        return makeFetchBookmarkedCollectionsUseCase(userRepository: makeUserRepository())
    }
    func makeFetchBookmarkedCollectionsUseCase(userRepository: UserRepository) -> FetchBookmarkedCollectionsUseCase {
        return DefaultFetchBookmarkedCollectionsUseCase(userRepository: userRepository)
    }
}
