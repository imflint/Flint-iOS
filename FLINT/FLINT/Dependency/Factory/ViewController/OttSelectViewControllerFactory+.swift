//
//  OttSelectViewControllerFactory+.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.30.
//

import Foundation

import Presentation

extension OttSelectViewControllerFactory where Self: ViewControllerFactory {
    func makeOttSelectViewController(onboardingViewModel: OnboardingViewModel) -> OttSelectViewController {
        return OttSelectViewController(onboardingViewModel: onboardingViewModel, viewControllerFactory: self)
    }
}
