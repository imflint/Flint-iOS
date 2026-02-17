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
}

extension SocialVerifyUseCaseFactory {
    func makeSocialVerifyUseCase() -> SocialVerifyUseCase {
        return DefaultSocialVerifyUseCase(authRepository: makeAuthRepository())
    }
}
