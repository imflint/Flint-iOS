//
//  LoginViewModelFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.23.
//

import Foundation

import Domain
import Presentation

protocol LoginViewModelFactory: SocialVerifyUseCaseFactory {
    func makeLoginViewModel() -> LoginViewModel
    func makeLoginViewModel(socialVerifyUseCase: SocialVerifyUseCase) -> LoginViewModel
}

extension LoginViewModelFactory {
    func makeLoginViewModel() -> LoginViewModel {
        return makeLoginViewModel(socialVerifyUseCase: makeSocialVerifyUseCase())
    }
    func makeLoginViewModel(socialVerifyUseCase: SocialVerifyUseCase) -> LoginViewModel {
        return DefaultLoginViewModel(socialVerifyUseCase: socialVerifyUseCase)
    }
}
