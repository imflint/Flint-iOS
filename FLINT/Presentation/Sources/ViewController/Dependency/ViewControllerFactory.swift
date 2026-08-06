//
//  ViewControllerFactory.swift
//  FLINT
//
//  Created by 진소은 on 1/10/26.
//

import UIKit

import ViewModel

public typealias ViewControllerFactory =
    
    // MARK: - Splash / Login
    
    SplashViewControllerFactory &
    LoginViewControllerFactory &
    
    // MARK: - Onboarding
    
    NicknameViewControllerFactory &
    ContentSelectViewControllerFactory &
//    OttSelectViewControllerFactory &
    OnboardingDoneViewControllerFactory &
    TermsAgreementViewControllerFactory &
    
    // MARK: - Main
    
    TabBarViewControllerFactory &
    HomeViewControllerFactory &
    ExploreViewControllerFactory &
    ProfileViewControllerFactory &
    
    // MARK: - Collection

    CollectionFolderListViewControllerFactory &
    CollectionDetailViewControllerFactory &
    SavedCollectionListViewControllerFactory &
    AddContentSelectViewControllerFactory &
    CreateCollectionViewControllerFactory &
    ReportViewControllerFactory
