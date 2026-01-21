//
//  CatFactory.swift
//  CleanArchitectureMVVM
//
//  Created by 김호성 on 2025.12.05.
//

import Foundation

import Data
import Domain
import Presentation

protocol OnboardingFactory {
    func makeUserService() -> UserService
    
    func makeUserRepository() -> UserRepository
    func makeUserRepository(userService: UserService) -> UserRepository
    
    func makeNicknameUseCase() -> NicknameUseCase
    func makeNicknameUseCase(userRepository: UserRepository) -> NicknameUseCase
    
    func makeOnboardingViewModel() -> OnboardingViewModel
    func makeOnboardingViewModel(nicknameUseCase: NicknameUseCase) -> OnboardingViewModel
}

extension OnboardingFactory {
    func makeUserRepository() -> UserRepository {
        return makeUserRepository(userService: makeUserService())
    }
    func makeUserRepository(userService: UserService) -> UserRepository {
        return DefaultUserRepository(userService: userService)
    }
    
    func makeNicknameUseCase() -> NicknameUseCase {
        return makeNicknameUseCase(userRepository: makeUserRepository())
    }
    func makeNicknameUseCase(userRepository: UserRepository) -> NicknameUseCase {
        return DefaultNicknameUseCase(userRepository: userRepository)
    }
    
    func makeOnboardingViewModel() -> OnboardingViewModel {
        return makeOnboardingViewModel(nicknameUseCase: makeNicknameUseCase())
    }
    func makeOnboardingViewModel(nicknameUseCase: NicknameUseCase) -> OnboardingViewModel {
        return DefaultOnboardingViewModel(nicknameUseCase: nicknameUseCase)
    }
}
