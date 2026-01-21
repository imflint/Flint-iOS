//
//  DIContainer.swift
//  CleanArchitectureMVVM
//
//  Created by 김호성 on 2025.12.05.
//

import UIKit
import Combine

import Moya

import Data
import Domain
import Presentation

typealias AppFactory = ViewControllerFactory & OnboardingFactory  & CreateCollectionFactory

final class DIContainer: AppFactory {
    
    // MARK: - Root Dependency
    
    private lazy var userAPIProvider = MoyaProvider<UserAPI>()
//    private lazy var searchService: SearchService = DefaultSearchService()
    private lazy var collectionAPIProvider = MoyaProvider<CollectionAPI>()
    
    // MARK: - Init
    
    init() {
        
    }
    
    // MARK: - ViewControllerFactory
    
    func makeTabBarViewController() -> TabBarViewController {
        return TabBarViewController(viewControllerFactory: self)
    }
    
    func makeNicknameViewController(onboardingViewModel: OnboardingViewModel) -> NicknameViewController {
        return NicknameViewController(onboardingViewModel: makeOnboardingViewModel(), viewControllerFactory: self)
    }
    
    func makeCreateCollectionViewController() -> CreateCollectionViewController {
        return CreateCollectionViewController(viewModel: makeCreateCollectionViewModel(), viewControllerFactory: self)
    }
    
    // MARK: - Root Dependency Injection
    func makeUserAPIProvider() -> MoyaProvider<UserAPI> {
        return userAPIProvider
    }
    
    func makeCollectionAPIProvider() -> MoyaProvider<CollectionAPI> {
        collectionAPIProvider
    }
}
