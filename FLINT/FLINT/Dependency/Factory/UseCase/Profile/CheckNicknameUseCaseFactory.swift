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
}

extension CheckNicknameUseCaseFactory {
    func makeCheckNicknameUseCase() -> CheckNicknameUseCase {
        return DefaultCheckNicknameUseCase(userRepository: makeUserRepository())
    }
}
