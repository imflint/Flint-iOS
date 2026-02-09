//
//  CheckNicknameUseCaseFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

import Domain

protocol CheckNicknameUseCaseFactory: UserRepositoryFactory {
    func makeCheckNicknameUseCase() -> CheckNicknameUseCase
    func makeCheckNicknameUseCase(userRepository: UserRepository) -> CheckNicknameUseCase
}

extension CheckNicknameUseCaseFactory {
    func makeCheckNicknameUseCase() -> CheckNicknameUseCase {
        return makeCheckNicknameUseCase(userRepository: makeUserRepository())
    }
    func makeCheckNicknameUseCase(userRepository: UserRepository) -> CheckNicknameUseCase {
        return DefaultCheckNicknameUseCase(userRepository: userRepository)
    }
}
