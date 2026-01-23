//
//  SocialVerifyUseCaseFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.23.
//

import Foundation

import Domain

protocol SocialVerifyUseCaseFactory: AuthRepositoryFactory {
    func makeSocialVerifyUseCase() -> SocialVerifyUseCase
    func makeSocialVerifyUseCase(authRepository: AuthRepository) -> SocialVerifyUseCase
}

extension SignupUseCaseFactory {
    func makeSocialVerifyUseCase() -> SocialVerifyUseCase {
        return makeSocialVerifyUseCase(authRepository: makeAuthRepository())
    }
    func makeSocialVerifyUseCase(authRepository: AuthRepository) -> SocialVerifyUseCase {
        return DefaultSocialVerifyUseCase(authRepository: authRepository)
    }
}
