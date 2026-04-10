//
//  FilmSelectViewControllerFactory+.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.30.
//

import Foundation

import Presentation

extension FilmSelectViewControllerFactory where Self: ViewControllerFactory {
    func makeFilmSelectViewController(onboardingViewModel: OnboardingViewModel) -> FilmSelectViewController {
        return FilmSelectViewController(onboardingViewModel: onboardingViewModel, viewControllerFactory: self)
    }
}
