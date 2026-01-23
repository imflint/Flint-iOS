//
//  File.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

import Domain

protocol NicknameUseCaseFactory: UserRepositoryFactory {
    func makeNicknameUseCase() -> NicknameUseCase
    func makeNicknameUseCase(userRepository: UserRepository) -> NicknameUseCase
}

extension NicknameUseCaseFactory {
    func makeNicknameUseCase() -> NicknameUseCase {
        return makeNicknameUseCase(userRepository: makeUserRepository())
    }
    func makeNicknameUseCase(userRepository: UserRepository) -> NicknameUseCase {
        return DefaultNicknameUseCase(userRepository: userRepository)
    }
}
