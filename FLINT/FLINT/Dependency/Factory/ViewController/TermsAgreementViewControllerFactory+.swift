//
//  TermsAgreementViewControllerFactory+.swift
//  FLINT
//
//  Created by 김호성 on 2026.05.29.
//

import Foundation

import Presentation

extension TermsAgreementViewControllerFactory where Self: OnboardingViewModelFactory & ViewControllerFactory {
    func makeTermsAgreementViewController() -> TermsAgreementViewController {
        return TermsAgreementViewController(onboardingViewModel: makeOnboardingViewModel(), viewControllerFactory: self)
    }
}
