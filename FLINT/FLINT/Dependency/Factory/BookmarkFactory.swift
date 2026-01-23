//
//  BookmarkFactory.swift
//  FLINT
//
//  Created by 진소은 on 1/23/26.
//

import Foundation
import Moya

import Data
import Domain
import Presentation

protocol BookmarkFactory: BookmarkRepositoryFactory {

    // UseCase
    func makeFetchBookmarkedUserUseCase() -> FetchBookmarkedUserUseCase
    func makeFetchBookmarkedUserUseCase(bookmarkRepository: BookmarkRepository) -> FetchBookmarkedUserUseCase
}

extension BookmarkFactory {

    func makeFetchBookmarkedUserUseCase() -> FetchBookmarkedUserUseCase {
        return makeFetchBookmarkedUserUseCase(bookmarkRepository: makeBookmarkRepository())
    }

    func makeFetchBookmarkedUserUseCase(bookmarkRepository: BookmarkRepository) -> FetchBookmarkedUserUseCase {
        return DefaultFetchBookmarkedUserUseCase(bookmarkRepository: bookmarkRepository)
    }
}
