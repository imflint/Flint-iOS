//
//  FetchBookmarkedContentsPageUseCaseFactory.swift
//  FLINT
//
//  Created by 진소은 on 8/20/26.
//

import Foundation

import Domain

protocol FetchBookmarkedContentsPageUseCaseFactory: ContentRepositoryFactory {
    func makeFetchBookmarkedContentsPageUseCase() -> FetchBookmarkedContentsPageUseCase
}

extension FetchBookmarkedContentsPageUseCaseFactory {
    func makeFetchBookmarkedContentsPageUseCase() -> FetchBookmarkedContentsPageUseCase {
        return DefaultFetchBookmarkedContentsPageUseCase(contentRepository: makeContentRepository())
    }
}
