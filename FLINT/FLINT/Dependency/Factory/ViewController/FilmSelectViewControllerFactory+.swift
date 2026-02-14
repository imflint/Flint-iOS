//
//  ContentSelectViewControllerFactory+.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.30.
//

import Foundation

import Presentation

extension ContentSelectViewControllerFactory where Self: ViewControllerFactory {
    func makeContentSelectViewController(onboardingViewModel: OnboardingViewModel) -> ContentSelectViewController {
        return ContentSelectViewController(onboardingViewModel: onboardingViewModel, viewControllerFactory: self)
    }
}
