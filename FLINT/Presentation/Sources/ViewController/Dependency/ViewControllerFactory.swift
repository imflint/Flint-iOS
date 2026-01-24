//
//  ViewControllerFactory.swift
//  FLINT
//
//  Created by 진소은 on 1/10/26.
//

import UIKit

import ViewModel

public protocol ViewControllerFactory {
    func makeSplashViewController() -> SplashViewController
    func makeLoginViewController() -> LoginViewController

    func makeNicknameViewController() -> NicknameViewController
    
    func makeFilmSelectViewController(onboardingViewModel: OnboardingViewModel) -> FilmSelectViewController
    func makeOttSelectViewController(onboardingViewModel: OnboardingViewModel) -> OttSelectViewController
    func makeOnboardingDoneViewController(onboardingViewModel: OnboardingViewModel) -> OnboardingDoneViewController
    
    func makeTabBarViewController() -> TabBarViewController
    
    func makeHomeViewController() -> HomeViewController
    func makeExploreViewController() -> ExploreViewController
    
    func makeAddContentSelectViewController() -> AddContentSelectViewController
    func makeCreateCollectionViewController() -> CreateCollectionViewController
    
    func makeProfileViewController() -> ProfileViewController
    
    func makeCollectionDetailViewController(collectionId: Int64) -> CollectionDetailViewController
    
    func makeCollectionFolderListViewController() -> CollectionFolderListViewController

}
