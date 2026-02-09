//
//  HomeViewModelFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.02.
//

import Foundation

import Domain
import Presentation

protocol HomeViewModelFactory: FetchRecommendedCollectionsUseCaseFactory, FetchBookmarkedContentsUseCaseFactory, FetchProfileUseCaseFactory, FetchRecentViewedCollectionsUseCaseFactory {
    func makeHomeViewModel() -> HomeViewModel
    func makeHomeViewModel(
        fetchRecommendedCollectionsUseCase: FetchRecommendedCollectionsUseCase,
        fetchBookmarkedContentsUseCase: FetchBookmarkedContentsUseCase,
        fetchProfileUseCase: FetchProfileUseCase,
        fetchRecentViewedCollectionsUseCase: FetchRecentViewedCollectionsUseCase,
        initialUserName: String
    ) -> HomeViewModel
}

extension HomeViewModelFactory {
    func makeHomeViewModel() -> HomeViewModel {
        return makeHomeViewModel(
            fetchRecommendedCollectionsUseCase: makeFetchRecommendedCollectionsUseCase(),
            fetchBookmarkedContentsUseCase: makeFetchBookmarkedContentsUseCase(),
            fetchProfileUseCase: makeFetchProfileUseCase(),
            fetchRecentViewedCollectionsUseCase: makeFetchRecentViewedCollectionsUseCase(),
            initialUserName: "얀비"
        )
    }

    func makeHomeViewModel(
        fetchRecommendedCollectionsUseCase: FetchRecommendedCollectionsUseCase,
        fetchBookmarkedContentsUseCase: FetchBookmarkedContentsUseCase,
        fetchProfileUseCase: FetchProfileUseCase,
        fetchRecentViewedCollectionsUseCase: FetchRecentViewedCollectionsUseCase,
        initialUserName: String
    ) -> HomeViewModel {
        return HomeViewModel(
            fetchRecommendedCollectionsUseCase: fetchRecommendedCollectionsUseCase,
            fetchBookmarkedContentsUseCase: fetchBookmarkedContentsUseCase,
            fetchProfileUseCase: fetchProfileUseCase,
            fetchRecentViewedCollectionsUseCase: fetchRecentViewedCollectionsUseCase,
            initialUserName: "얀비"
        )
    }
}
