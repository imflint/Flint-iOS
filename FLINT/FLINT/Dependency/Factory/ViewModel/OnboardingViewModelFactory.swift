//
//  OnboardingViewModelFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

import Domain
import Presentation

protocol OnboardingViewModelFactory: CheckNicknameUseCaseFactory, SearchContentsUseCaseFactory, FetchPopularContentsUseCaseFactory, SignupUseCaseFactory {
    func makeOnboardingViewModel() -> OnboardingViewModel
    func makeOnboardingViewModel(checkNicknameUseCase: CheckNicknameUseCase, fetchPopularContentsUseCase: FetchPopularContentsUseCase, searchContentsUseCase: SearchContentsUseCase, signupUseCase: SignupUseCase) -> OnboardingViewModel
}

extension OnboardingViewModelFactory {
    func makeOnboardingViewModel() -> OnboardingViewModel {
        return makeOnboardingViewModel(
            checkNicknameUseCase: makeCheckNicknameUseCase(),
            fetchPopularContentsUseCase: makeFetchPopularContentsUseCase(),
            searchContentsUseCase: makeSearchContentsUseCase(),
            signupUseCase: makeSignupUseCase()
        )
    }
    func makeOnboardingViewModel(checkNicknameUseCase: CheckNicknameUseCase, fetchPopularContentsUseCase: FetchPopularContentsUseCase, searchContentsUseCase: SearchContentsUseCase, signupUseCase: SignupUseCase) -> OnboardingViewModel {
        return DefaultOnboardingViewModel(checkNicknameUseCase: checkNicknameUseCase, fetchPopularContentsUseCase: fetchPopularContentsUseCase, searchContentsUseCase: searchContentsUseCase, signupUseCase: signupUseCase)
    }
}
