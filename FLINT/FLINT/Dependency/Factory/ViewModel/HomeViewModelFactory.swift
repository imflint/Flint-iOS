//
//  HomeViewModelFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.02.
//

import Foundation

import Presentation

protocol HomeViewModelFactory:
    FetchRecommendedCollectionsUseCaseFactory,
    FetchPopularCollectionsUseCaseFactory,
    FetchBookmarkedContentsUseCaseFactory,
    FetchProfileUseCaseFactory,
    FetchRecentViewedCollectionsUseCaseFactory {
    func makeHomeViewModel() -> HomeViewModel
}

extension HomeViewModelFactory {
    func makeHomeViewModel() -> HomeViewModel {
        return HomeViewModel(
            fetchRecommendedCollectionsUseCase: makeFetchRecommendedCollectionsUseCase(),
            fetchPopularCollectionsUseCase: makeFetchPopularCollectionsUseCase(),
            fetchBookmarkedContentsUseCase: makeFetchBookmarkedContentsUseCase(),
            fetchProfileUseCase: makeFetchProfileUseCase(),
            fetchRecentViewedCollectionsUseCase: makeFetchRecentViewedCollectionsUseCase()
        )
    }
}
