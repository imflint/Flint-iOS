//
//  BookmarkServiceFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.31.
//

import Foundation

import Data

protocol BookmarkServiceFactory: BookmarkAPIProviderFactory {
    func makeBookmarkService() -> BookmarkService
}

extension BookmarkServiceFactory {
    func makeBookmarkService() -> BookmarkService {
        return DefaultBookmarkService(bookmarkAPIProvider: makeBookmarkAPIProvider())
    }
}
