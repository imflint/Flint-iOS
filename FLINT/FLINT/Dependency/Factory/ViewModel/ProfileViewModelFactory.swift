//
//  ProfileViewModelFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.02.
//

import Foundation

import Domain
import Presentation

protocol ProfileViewModelFactory: UserProfileUseCaseFactory {
    func makeProfileViewModel() -> ProfileViewModel
    func makeProfileViewModel(
            target: ProfileViewModel.Target
        ) -> ProfileViewModel
}

extension ProfileViewModelFactory {
    func makeProfileViewModel() -> ProfileViewModel {
        return makeProfileViewModel(target: .me)
    }
    
    func makeProfileViewModel(
        target: ProfileViewModel.Target
    ) -> ProfileViewModel {
        return ProfileViewModel(
            target: target,
            userProfileUseCase: makeUserProfileUseCase()
        )
    }
}
