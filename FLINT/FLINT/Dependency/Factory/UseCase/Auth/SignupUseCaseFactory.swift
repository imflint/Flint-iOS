//
//  SignupUseCase.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.23.
//

import Foundation

import Domain

protocol SignupUseCaseFactory: AuthRepositoryFactory {
    func makeSignupUseCase() -> SignupUseCase
    func makeSignupUseCase(authRepository: AuthRepository) -> SignupUseCase
}

extension SignupUseCaseFactory {
    func makeSignupUseCase() -> SignupUseCase {
        return makeSignupUseCase(authRepository: makeAuthRepository())
    }
    func makeSignupUseCase(authRepository: AuthRepository) -> SignupUseCase {
        return DefaultSignupUseCase(authRepository: authRepository)
    }
}
