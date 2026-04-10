//
//  NicknameViewControllerFactory+.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.30.
//

import Foundation

import Presentation

extension NicknameViewControllerFactory where Self: OnboardingViewModelFactory & ViewControllerFactory {
    func makeNicknameViewController() -> NicknameViewController {
        return NicknameViewController(onboardingViewModel: makeOnboardingViewModel(), viewControllerFactory: self)
    }
}
