//
//  ProfileViewControllerFactory+.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.31.
//

import Foundation

import Presentation

extension ProfileViewControllerFactory where Self: ProfileFactory & ViewControllerFactory {
    func makeProfileViewController() -> ProfileViewController {
        makeProfileViewController(target: .me)
    }

    func makeProfileViewController(
        target: ProfileViewModel.Target = .me
    ) -> ProfileViewController {
        return ProfileViewController(
            profileViewModel: makeProfileViewModel(target: target),
            viewControllerFactory: self
        )
    }
}
