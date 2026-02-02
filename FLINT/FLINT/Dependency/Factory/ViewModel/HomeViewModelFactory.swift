//
//  HomeViewModelFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.02.
//

import Foundation

import Domain
import Presentation

protocol HomeViewModelFactory: HomeUseCaseFactory, UserProfileUseCaseFactory, FetchWatchingCollectionsUseCaseFactory {
    func makeHomeViewModel() -> HomeViewModel
    func makeHomeViewModel(
        homeUseCase: HomeUseCase,
        userProfileUseCase: UserProfileUseCase,
        fetchWatchingCollectionsUseCase: FetchWatchingCollectionsUseCase
    ) -> HomeViewModel
}

extension HomeViewModelFactory {
    func makeHomeViewModel() -> HomeViewModel {
        return makeHomeViewModel(
            homeUseCase: makeHomeUseCase(),
            userProfileUseCase: makeUserProfileUseCase(),
            fetchWatchingCollectionsUseCase: makeFetchWatchingCollectionsUseCase()
        )
    }

    func makeHomeViewModel(
        homeUseCase: HomeUseCase,
        userProfileUseCase: UserProfileUseCase,
        fetchWatchingCollectionsUseCase: FetchWatchingCollectionsUseCase
    ) -> HomeViewModel {
        return HomeViewModel(
            homeUseCase: homeUseCase,
            userProfileUseCase: userProfileUseCase,
            fetchWatchingCollectionsUseCase: fetchWatchingCollectionsUseCase,
            initialUserName: "얀비"
        )
    }
}
