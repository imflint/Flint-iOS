//
//  NicknameViewControllerFactory+.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.30.
//

import Foundation

import Presentation

extension NicknameViewControllerFactory where Self: ViewControllerFactory {
    func makeNicknameViewController(onboardingViewModel: OnboardingViewModel) -> NicknameViewController {
        return NicknameViewController(onboardingViewModel: onboardingViewModel, viewControllerFactory: self)
    }
}
