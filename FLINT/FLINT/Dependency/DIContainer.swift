//
//  DIContainer.swift
//  CleanArchitectureMVVM
//
//  Created by 김호성 on 2025.12.05.
//

import UIKit
import Combine

import Data
import Domain
import Presentation

typealias AppFactory = ViewControllerFactory & OnboardingFactory

final class DIContainer: AppFactory {
    
    // MARK: - Root Dependency
    
    private lazy var userService: UserService = DefaultUserService()
    
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
    
    // MARK: - Root Dependency Injection
    func makeUserService() -> UserService {
        return userService
    }
}
