//
//  BookmarkAPIProviderFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.31.
//

import Foundation
import Moya

import Data

protocol BookmarkAPIProviderFactory {
    var bookmarkAPIProvider: MoyaProvider<BookmarkAPI> { get set }
    
    func makeBookmarkAPIProvider() -> MoyaProvider<BookmarkAPI>
}

extension BookmarkAPIProviderFactory {
    func makeBookmarkAPIProvider() -> MoyaProvider<BookmarkAPI> {
        return bookmarkAPIProvider
    }
}
