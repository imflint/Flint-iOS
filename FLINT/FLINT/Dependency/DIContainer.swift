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

typealias AppFactory = ViewControllerFactory & OnboardingFactory

final class DIContainer: AppFactory {
    
    // MARK: - Root Dependency
    
    private lazy var userAPIProvider = MoyaProvider<UserAPI>()
//    private lazy var searchService: SearchService = DefaultSearchService()
    
    // MARK: - Init
    
    init() {
        
    }
    
    // MARK: - ViewControllerFactory
    
    func makeTabBarViewController() -> TabBarViewController {
        return TabBarViewController(viewControllerFactory: self)
    }
    
    func makeNicknameViewController() -> NicknameViewController {
        return NicknameViewController(onboardingViewModel: makeOnboardingViewModel(), viewControllerFactory: self)
    }
    
    // MARK: - Root Dependency Injection
    func makeUserAPIProvider() -> MoyaProvider<UserAPI> {
        return userAPIProvider
    }
}
