//
//  BookmarkRepositoryFactory.swift
//  FLINT
//
//  Created by 진소은 on 1/23/26.
//

import Foundation
import Moya

import Data
import Domain

protocol BookmarkRepositoryFactory {
    func makeBookmarkAPIProvider() -> MoyaProvider<BookmarkAPI>

    // Service
    func makeBookmarkService() -> BookmarkService
    func makeBookmarkService(provider: MoyaProvider<BookmarkAPI>) -> BookmarkService

    // Repository
    func makeBookmarkRepository() -> BookmarkRepository
    func makeBookmarkRepository(bookmarkService: BookmarkService) -> BookmarkRepository
}

extension BookmarkRepositoryFactory {

    // Service
    func makeBookmarkService() -> BookmarkService {
        return makeBookmarkService(provider: makeBookmarkAPIProvider())
    }

    func makeBookmarkService(provider: MoyaProvider<BookmarkAPI>) -> BookmarkService {
        return DefaultBookmarkService(provider: provider)
    }

    // Repository
    func makeBookmarkRepository() -> BookmarkRepository {
        return makeBookmarkRepository(bookmarkService: makeBookmarkService())
    }

    func makeBookmarkRepository(bookmarkService: BookmarkService) -> BookmarkRepository {
        return DefaultBookmarkRepository(bookmarkService: bookmarkService)
    }
}
