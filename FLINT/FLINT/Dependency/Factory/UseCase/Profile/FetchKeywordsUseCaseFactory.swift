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
}

extension FetchKeywordsUseCaseFactory {
    func makeFetchKeywordsUseCase() -> FetchKeywordsUseCase {
        return DefaultFetchKeywordsUseCase(userRepository: makeUserRepository())
    }
}
