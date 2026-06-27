//
//  SettingViewControllerFactory+.swift
//  FLINT
//
//  Created by 소은 on 6/19/26.
//

import Foundation

import Presentation

extension SettingViewControllerFactory where Self: SettingViewModelFactory & ViewControllerFactory {
    func makeSettingViewController() -> SettingViewController {
        return SettingViewController(
            settingViewModel: makeSettingViewModel(),
            viewControllerFactory: self
        )
    }
}
