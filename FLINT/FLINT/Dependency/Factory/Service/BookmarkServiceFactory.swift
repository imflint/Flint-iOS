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
    func makeBookmarkService(provider: MoyaProvider<BookmarkAPI>) -> BookmarkService
}

extension BookmarkServiceFactory {
    func makeBookmarkService() -> BookmarkService {
        return makeBookmarkService(provider: makeBookmarkAPIProvider())
    }
    func makeBookmarkService(provider: MoyaProvider<BookmarkAPI>) -> BookmarkService {
        return DefaultBookmarkService(provider: provider)
    }
}
