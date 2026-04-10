//
//  FetchProfileUseCaseFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.09.
//

import Foundation

import Domain

protocol FetchProfileUseCaseFactory: UserRepositoryFactory {
    func makeFetchProfileUseCase() -> FetchProfileUseCase
}

extension FetchProfileUseCaseFactory {
    func makeFetchProfileUseCase() -> FetchProfileUseCase {
        return DefaultFetchProfileUseCase(userRepository: makeUserRepository())
    }
}
