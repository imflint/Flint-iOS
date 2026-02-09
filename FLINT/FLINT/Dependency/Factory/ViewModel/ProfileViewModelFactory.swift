//
//  ProfileViewModelFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.02.
//

import Foundation

import Domain
import Presentation

protocol ProfileViewModelFactory: FetchProfileUseCaseFactory, FetchKeywordsUseCaseFactory, FetchCreatedCollectionsUseCaseFactory, FetchBookmarkedCollectionsUseCaseFactory, FetchBookmarkedContentsUseCaseFactory {
    func makeProfileViewModel(target: UserTarget) -> ProfileViewModel
    func makeProfileViewModel(
        target: UserTarget,
        fetchProfileUseCase: FetchProfileUseCase,
        fetchKeywordsUseCase: FetchKeywordsUseCase,
        fetchCreatedCollectionsUseCase: FetchCreatedCollectionsUseCase,
        fetchBookmarkedCollectionsUseCase: FetchBookmarkedCollectionsUseCase,
        fetchBookmarkedContentsUseCase: FetchBookmarkedContentsUseCase
    ) -> ProfileViewModel
}

extension ProfileViewModelFactory {
    func makeProfileViewModel(target: UserTarget) -> ProfileViewModel {
        return makeProfileViewModel(
            target: target,
            fetchProfileUseCase: makeFetchProfileUseCase(),
            fetchKeywordsUseCase: makeFetchKeywordsUseCase(),
            fetchCreatedCollectionsUseCase: makeFetchCreatedCollectionsUseCase(),
            fetchBookmarkedCollectionsUseCase: makeFetchBookmarkedCollectionsUseCase(),
            fetchBookmarkedContentsUseCase: makeFetchBookmarkedContentsUseCase()
        )
    }
    func makeProfileViewModel(
        target: UserTarget,
        fetchProfileUseCase: FetchProfileUseCase,
        fetchKeywordsUseCase: FetchKeywordsUseCase,
        fetchCreatedCollectionsUseCase: FetchCreatedCollectionsUseCase,
        fetchBookmarkedCollectionsUseCase: FetchBookmarkedCollectionsUseCase,
        fetchBookmarkedContentsUseCase: FetchBookmarkedContentsUseCase
    ) -> ProfileViewModel {
        return ProfileViewModel(
            target: target,
            fetchProfileUseCase: fetchProfileUseCase,
            fetchKeywordsUseCase: fetchKeywordsUseCase,
            fetchCreatedCollectionsUseCase: fetchCreatedCollectionsUseCase,
            fetchBookmarkedCollectionsUseCase: fetchBookmarkedCollectionsUseCase,
            fetchBookmarkedContentsUseCase: fetchBookmarkedContentsUseCase
        )
    }
}
