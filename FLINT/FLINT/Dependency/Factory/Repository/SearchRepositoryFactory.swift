//
//  SearchRepositoryFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

import Data
import Domain

protocol SearchRepositoryFactory: SearchServiceFactory {
    func makeSearchRepository() -> SearchRepository
    func makeSearchRepository(searchService: SearchService) -> SearchRepository
}

extension SearchRepositoryFactory {
    func makeSearchRepository() -> SearchRepository {
        return makeSearchRepository(searchService: makeSearchService())
    }
    func makeSearchRepository(searchService: SearchService) -> SearchRepository {
        return DefaultSearchRepository(searchService: searchService)
    }
}
