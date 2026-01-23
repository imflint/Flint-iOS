//
//  SearchServiceFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

import Moya

import Data

protocol SearchServiceFactory: SearchAPIFactory {
    func makeSearchService() -> SearchService
    func makeSearchService(searchAPIProvider: MoyaProvider<SearchAPI>) -> SearchService
}

extension SearchServiceFactory {
    func makeSearchService() -> SearchService {
        return makeSearchService(searchAPIProvider: makeSearchAPIProvider())
    }
    func makeSearchService(searchAPIProvider: MoyaProvider<SearchAPI>) -> SearchService {
        return DefaultSearchService(provider: searchAPIProvider)
    }
}
