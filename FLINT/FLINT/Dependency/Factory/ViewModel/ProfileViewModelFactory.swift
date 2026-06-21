//
//  ProfileViewModelFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.02.
//

import Foundation

import Domain
import Presentation

protocol ProfileViewModelFactory: FetchProfileUseCaseFactory, FetchKeywordsUseCaseFactory, FetchCreatedCollectionsUseCaseFactory, FetchBookmarkedCollectionsUseCaseFactory, FetchBookmarkedContentsUseCaseFactory, RecalculateKeywordsUseCaseFactory {
    func makeProfileViewModel(target: UserTarget) -> ProfileViewModel
}

extension ProfileViewModelFactory {
    func makeProfileViewModel(target: UserTarget) -> ProfileViewModel {
        return ProfileViewModel(
            target: target,
            fetchProfileUseCase: makeFetchProfileUseCase(),
            fetchKeywordsUseCase: makeFetchKeywordsUseCase(),
            fetchCreatedCollectionsUseCase: makeFetchCreatedCollectionsUseCase(),
            fetchBookmarkedCollectionsUseCase: makeFetchBookmarkedCollectionsUseCase(),
            fetchBookmarkedContentsUseCase: makeFetchBookmarkedContentsUseCase(),
            recalculateKeywordsUseCase: makeRecalculateKeywordsUseCase()
        )
    }
}
