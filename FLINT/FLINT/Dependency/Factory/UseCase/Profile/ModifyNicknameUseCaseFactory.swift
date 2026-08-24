//
//  ModifyNicknameUseCaseFactory.swift
//  FLINT
//
//  Created by Hosung.Kim on 2026.08.24.
//

import Foundation

import Domain

protocol ModifyNicknameUseCaseFactory: UserRepositoryFactory {
    func makeModifyNicknameUseCase() -> ModifyNicknameUseCase
}

extension ModifyNicknameUseCaseFactory {
    func makeModifyNicknameUseCase() -> ModifyNicknameUseCase {
        return DefaultModifyNicknameUseCase(userRepository: makeUserRepository())
    }
}
