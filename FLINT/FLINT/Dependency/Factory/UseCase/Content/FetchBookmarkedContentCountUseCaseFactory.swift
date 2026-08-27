//
//  FetchBookmarkedContentCountUseCaseFactory.swift
//  FLINT
//
//  Created by 진소은 on 8/20/26.
//

import Foundation

import Domain

protocol FetchBookmarkedContentCountUseCaseFactory: ContentRepositoryFactory {
    func makeFetchBookmarkedContentCountUseCase() -> FetchBookmarkedContentCountUseCase
}

extension FetchBookmarkedContentCountUseCaseFactory {
    func makeFetchBookmarkedContentCountUseCase() -> FetchBookmarkedContentCountUseCase {
        return DefaultFetchBookmarkedContentCountUseCase(contentRepository: makeContentRepository())
    }
}
