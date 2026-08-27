//
//  SettingViewModelFactory.swift
//  FLINT
//
//  Created by 소은 on 6/19/26.
//

import Foundation

import Presentation

protocol SettingViewModelFactory: LogoutUseCaseFactory, FetchProfileUseCaseFactory {
    func makeSettingViewModel() -> any SettingViewModel
}

extension SettingViewModelFactory {
    func makeSettingViewModel() -> any SettingViewModel {
        return DefaultSettingViewModel(
            logoutUseCase: makeLogoutUseCase(),
            fetchProfileUseCase: makeFetchProfileUseCase()
        )
    }
}
