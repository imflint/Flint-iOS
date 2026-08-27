//
//  ProfileSettingViewModelFactory.swift
//  FLINT
//
//  Created by Hosung.Kim on 2026.08.24.
//

import Foundation

import Presentation

protocol ProfileSettingViewModelFactory: UploadUserProfileUseCaseFactory, CheckNicknameUseCaseFactory, ModifyNicknameUseCaseFactory, ModifyProfileImageUseCaseFactory {
    func makeProfileSettingViewModel() -> ProfileSettingViewModel
}

extension ProfileSettingViewModelFactory {
    func makeProfileSettingViewModel() -> ProfileSettingViewModel {
        return DefaultProfileSettingViewModel(
            uploadUserProfileUseCase: makeUploadUserProfileUseCase(),
            checkNicknameUseCase: makeCheckNicknameUseCase(),
            modifyNicknameUseCase: makeModifyNicknameUseCase(),
            modifyProfileImageUseCase: makeModifyProfileImageUseCase()
        )
    }
}
