//
//  ViewControllerFactory.swift
//  FLINT
//
//  Created by 진소은 on 1/10/26.
//

import UIKit

import ViewModel

public protocol ViewControllerFactory {
    func makeTabBarViewController() -> TabBarViewController
    func makeNicknameViewController() -> NicknameViewController
    func makeFilmSelectViewController(onboardingViewModel: OnboardingViewModel) -> FilmSelectViewController
    func makeExploreViewController() -> ExploreViewController
}
