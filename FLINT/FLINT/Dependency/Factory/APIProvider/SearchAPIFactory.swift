//
//  SearchAPIFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

import Moya

import Data

protocol SearchAPIFactory {
    var searchAPIProvider: MoyaProvider<SearchAPI> { get set }
    
    func makeSearchAPIProvider() -> MoyaProvider<SearchAPI>
}

extension SearchAPIFactory {
    func makeSearchAPIProvider() -> MoyaProvider<SearchAPI> {
        return searchAPIProvider
    }
}
