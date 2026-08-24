//
//  ProfileSettingViewControllerFactory+.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.31.
//

import Foundation

import Domain
import Presentation

extension ProfileSettingViewControllerFactory where Self: ProfileSettingViewModelFactory & ViewControllerFactory {
    func makeProfileSettingViewController(userProfile: UserProfileEntity) -> ProfileSettingViewController {
        return ProfileSettingViewController(userProfile: userProfile, profileSettingViewModel: makeProfileSettingViewModel(), viewControllerFactory: self)
    }
}
