//
//  HomeViewModelFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.02.
//

import Foundation

import Presentation

protocol HomeViewModelFactory: FetchRecommendedCollectionsUseCaseFactory, FetchBookmarkedContentsUseCaseFactory, FetchProfileUseCaseFactory, FetchRecentViewedCollectionsUseCaseFactory {
    func makeHomeViewModel() -> HomeViewModel
}

extension HomeViewModelFactory {
    func makeHomeViewModel() -> HomeViewModel {
        return HomeViewModel(fetchRecommendedCollectionsUseCase: makeFetchRecommendedCollectionsUseCase(), fetchBookmarkedContentsUseCase: makeFetchBookmarkedContentsUseCase(), fetchProfileUseCase: makeFetchProfileUseCase(), fetchRecentViewedCollectionsUseCase: makeFetchRecentViewedCollectionsUseCase())
    }
}
