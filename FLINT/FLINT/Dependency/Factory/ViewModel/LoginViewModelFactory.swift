//
//  LoginViewModelFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.23.
//

import Foundation

import Presentation

protocol LoginViewModelFactory: SocialVerifyUseCaseFactory {
    func makeLoginViewModel() -> LoginViewModel
}

extension LoginViewModelFactory {
    func makeLoginViewModel() -> LoginViewModel {
        return DefaultLoginViewModel(socialVerifyUseCase: makeSocialVerifyUseCase())
    }
}
