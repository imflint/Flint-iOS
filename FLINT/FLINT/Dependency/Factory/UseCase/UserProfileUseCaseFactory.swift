//
//  UserProfileUseCaseFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.31.
//

import Foundation

import Domain

protocol UserProfileUseCaseFactory: UserRepositoryFactory {
    func makeUserProfileUseCase() -> UserProfileUseCase
    func makeUserProfileUseCase(userRepository: UserRepository) -> UserProfileUseCase
}

extension UserProfileUseCaseFactory {
    func makeUserProfileUseCase() -> UserProfileUseCase {
        return makeUserProfileUseCase(userRepository: makeUserRepository())
    }
    func makeUserProfileUseCase(userRepository: UserRepository) -> UserProfileUseCase {
        return DefaultUserProfileUseCase(userRepository: userRepository)
    }
}
