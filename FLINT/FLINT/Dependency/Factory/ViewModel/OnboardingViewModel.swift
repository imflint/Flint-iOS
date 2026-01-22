//
//  File.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

import Domain
import Presentation

protocol OnboardingViewModelFactory: NicknameUseCaseFactory, SearchContentsUseCaseFactory, ContentsUseCaseFactory {
    func makeOnboardingViewModel() -> OnboardingViewModel
    func makeOnboardingViewModel(nicknameUseCase: NicknameUseCase, contentsUseCase: ContentsUseCase, searchContentsUseCase: SearchContentsUseCase) -> OnboardingViewModel
}

extension OnboardingViewModelFactory {
    func makeOnboardingViewModel() -> OnboardingViewModel {
        return makeOnboardingViewModel(nicknameUseCase: makeNicknameUseCase(), contentsUseCase: makeContentsUseCase(), searchContentsUseCase: makeSearchContentsUseCase())
    }
    func makeOnboardingViewModel(nicknameUseCase: NicknameUseCase, contentsUseCase: ContentsUseCase, searchContentsUseCase: SearchContentsUseCase) -> OnboardingViewModel {
        return DefaultOnboardingViewModel(nicknameUseCase: nicknameUseCase, contentsUseCase: contentsUseCase, searchContentsUseCase: searchContentsUseCase)
    }
}
