//
//  SearchAPIProviderFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

import Moya

import Data

protocol SearchAPIProviderFactory {
    var searchAPIProvider: MoyaProvider<SearchAPI> { get set }
    
    func makeSearchAPIProvider() -> MoyaProvider<SearchAPI>
}

extension SearchAPIProviderFactory {
    func makeSearchAPIProvider() -> MoyaProvider<SearchAPI> {
        return searchAPIProvider
    }
}
