//
//  ProfileFactory.swift
//  FLINT
//
//  Created by 진소은 on 1/22/26.
//
import Foundation

import Moya

import Data
import Domain
import Presentation

protocol ProfileFactory: UserRepositoryFactory {

    // MARK: - UseCase
    func makeUserProfileUseCase() -> UserProfileUseCase
    func makeUserProfileUseCase(userRepository: UserRepository) -> UserProfileUseCase

    // MARK: - ViewModel
    func makeProfileViewModel() -> ProfileViewModel
    func makeProfileViewModel(
            target: ProfileViewModel.Target
        ) -> ProfileViewModel
}

extension ProfileFactory {

    // MARK: - UseCase
    func makeUserProfileUseCase() -> UserProfileUseCase {
        return makeUserProfileUseCase(userRepository: makeUserRepository())
    }

    func makeUserProfileUseCase(userRepository: UserRepository) -> UserProfileUseCase {
        return DefaultUserProfileUseCase(userRepository: userRepository)
    }

    // MARK: - ViewModel

    func makeProfileViewModel() -> ProfileViewModel {
        makeProfileViewModel(target: .me)
    }
    
    func makeProfileViewModel(
        target: ProfileViewModel.Target
    ) -> ProfileViewModel {
        ProfileViewModel(
            target: target,
            userProfileUseCase: makeUserProfileUseCase()
        )
    }
}
