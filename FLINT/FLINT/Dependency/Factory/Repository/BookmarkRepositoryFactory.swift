//
//  BookmarkRepositoryFactory.swift
//  FLINT
//
//  Created by 진소은 on 1/23/26.
//

import Foundation

import Data
import Domain

protocol BookmarkRepositoryFactory: BookmarkServiceFactory {
    func makeBookmarkRepository() -> BookmarkRepository
    func makeBookmarkRepository(bookmarkService: BookmarkService) -> BookmarkRepository
}

extension BookmarkRepositoryFactory {
    func makeBookmarkRepository() -> BookmarkRepository {
        return makeBookmarkRepository(bookmarkService: makeBookmarkService())
    }
    func makeBookmarkRepository(bookmarkService: BookmarkService) -> BookmarkRepository {
        return DefaultBookmarkRepository(bookmarkService: bookmarkService)
    }
}
