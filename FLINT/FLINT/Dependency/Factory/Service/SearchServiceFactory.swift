//
//  SearchServiceFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

import Data

protocol SearchServiceFactory: SearchAPIProviderFactory {
    func makeSearchService() -> SearchService
}

extension SearchServiceFactory {
    func makeSearchService() -> SearchService {
        return DefaultSearchService(searchAPIProvider: makeSearchAPIProvider())
    }
}
