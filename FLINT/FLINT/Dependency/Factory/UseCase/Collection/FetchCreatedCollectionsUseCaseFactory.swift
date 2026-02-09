//
//  FetchCreatedCollectionsUseCaseFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.09.
//

import Foundation

import Domain

protocol FetchCreatedCollectionsUseCaseFactory: UserRepositoryFactory {
    func makeFetchCreatedCollectionsUseCase() -> FetchCreatedCollectionsUseCase
    func makeFetchCreatedCollectionsUseCase(userRepository: UserRepository) -> FetchCreatedCollectionsUseCase
}

extension FetchKeywordsUseCaseFactory {
    func makeFetchCreatedCollectionsUseCase() -> FetchCreatedCollectionsUseCase {
        return makeFetchCreatedCollectionsUseCase(userRepository: makeUserRepository())
    }
    func makeFetchCreatedCollectionsUseCase(userRepository: UserRepository) -> FetchCreatedCollectionsUseCase {
        return DefaultFetchCreatedCollectionsUseCase(userRepository: userRepository)
    }
}
