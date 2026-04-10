//
//  OnboardingViewModelFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

import Presentation

protocol OnboardingViewModelFactory: CheckNicknameUseCaseFactory, SearchContentsUseCaseFactory, FetchPopularContentsUseCaseFactory, SignupUseCaseFactory {
    func makeOnboardingViewModel() -> OnboardingViewModel
}

extension OnboardingViewModelFactory {
    func makeOnboardingViewModel() -> OnboardingViewModel {
        return DefaultOnboardingViewModel(checkNicknameUseCase: makeCheckNicknameUseCase(), fetchPopularContentsUseCase: makeFetchPopularContentsUseCase(), searchContentsUseCase: makeSearchContentsUseCase(), signupUseCase: makeSignupUseCase())
    }
}
