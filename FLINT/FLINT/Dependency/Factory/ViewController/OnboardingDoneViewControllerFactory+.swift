//
//  OnboardingDoneViewControllerFactory+.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.30.
//

import Foundation

import Presentation

extension OnboardingDoneViewControllerFactory where Self: ViewControllerFactory {
    func makeOnboardingDoneViewController(onboardingViewModel: OnboardingViewModel) -> OnboardingDoneViewController {
        return OnboardingDoneViewController(onboardingViewModel: onboardingViewModel, viewControllerFactory: self)
    }
}
