//
//  BookmarkServiceFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.31.
//

import Foundation

import Moya

import Data

protocol BookmarkServiceFactory: BookmarkAPIProviderFactory {
    func makeBookmarkService() -> BookmarkService
    func makeBookmarkService(bookmarkAPIProvider: MoyaProvider<BookmarkAPI>) -> BookmarkService
}

extension BookmarkServiceFactory {
    func makeBookmarkService() -> BookmarkService {
        return makeBookmarkService(bookmarkAPIProvider: makeBookmarkAPIProvider())
    }
    func makeBookmarkService(bookmarkAPIProvider: MoyaProvider<BookmarkAPI>) -> BookmarkService {
        return DefaultBookmarkService(bookmarkAPIProvider: bookmarkAPIProvider)
    }
}
