//
//  DIContainer.swift
//  CleanArchitectureMVVM
//
//  Created by 김호성 on 2025.12.05.
//

import Foundation
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
    func makeNicknameViewController(onboardingViewModel: OnboardingViewModel) -> NicknameViewController {
        return NicknameViewController(onboardingViewModel: makeOnboardingViewModel())
    }
    
    // MARK: - Root Dependency Injection
    func makeUserService() -> UserService {
        return userService
    }
}
