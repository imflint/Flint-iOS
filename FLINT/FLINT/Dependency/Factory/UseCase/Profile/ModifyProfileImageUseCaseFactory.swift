//
//  ModifyProfileImageUseCaseFactory.swift
//  FLINT
//
//  Created by Hosung.Kim on 2026.08.24.
//

import Foundation

import Domain

protocol ModifyProfileImageUseCaseFactory: UserRepositoryFactory {
    func makeModifyProfileImageUseCase() -> ModifyProfileImageUseCase
}

extension ModifyProfileImageUseCaseFactory {
    func makeModifyProfileImageUseCase() -> ModifyProfileImageUseCase {
        return DefaultModifyProfileImageUseCase(userRepository: makeUserRepository())
    }
}
