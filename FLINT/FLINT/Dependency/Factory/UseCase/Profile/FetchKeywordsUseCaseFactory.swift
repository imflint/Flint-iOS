//
//  FetchKeywordsUseCaseFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.09.
//

import Foundation

import Domain

protocol FetchKeywordsUseCaseFactory: UserRepositoryFactory {
    func makeFetchKeywordsUseCase() -> FetchKeywordsUseCase
    func makeFetchKeywordsUseCase(userRepository: UserRepository) -> FetchKeywordsUseCase
}

extension FetchKeywordsUseCaseFactory {
    func makeFetchKeywordsUseCase() -> FetchKeywordsUseCase {
        return makeFetchKeywordsUseCase(userRepository: makeUserRepository())
    }
    func makeFetchKeywordsUseCase(userRepository: UserRepository) -> FetchKeywordsUseCase {
        return DefaultFetchKeywordsUseCase(userRepository: userRepository)
    }
}
