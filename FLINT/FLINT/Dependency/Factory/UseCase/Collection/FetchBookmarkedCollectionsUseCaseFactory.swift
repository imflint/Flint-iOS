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
}

extension FetchBookmarkedCollectionsUseCaseFactory {
    func makeFetchBookmarkedCollectionsUseCase() -> FetchBookmarkedCollectionsUseCase {
        return DefaultFetchBookmarkedCollectionsUseCase(userRepository: makeUserRepository())
    }
}
