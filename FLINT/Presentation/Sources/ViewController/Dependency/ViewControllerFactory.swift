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
<<<<<<< HEAD
    func makeFilmSelectViewController(onboardingViewModel: OnboardingViewModel) -> FilmSelectViewController
=======
    func makeExploreViewController() -> ExploreViewController
>>>>>>> 6325fa2c8b5a3a91438bd354e898f0dc452134d8
}
