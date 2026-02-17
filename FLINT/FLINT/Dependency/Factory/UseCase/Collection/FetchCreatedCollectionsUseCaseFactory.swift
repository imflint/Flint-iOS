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
}

extension FetchKeywordsUseCaseFactory {
    func makeFetchCreatedCollectionsUseCase() -> FetchCreatedCollectionsUseCase {
        return DefaultFetchCreatedCollectionsUseCase(userRepository: makeUserRepository())
    }
}
