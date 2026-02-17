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
}

extension SearchRepositoryFactory {
    func makeSearchRepository() -> SearchRepository {
        return DefaultSearchRepository(searchService: makeSearchService())
    }
}
