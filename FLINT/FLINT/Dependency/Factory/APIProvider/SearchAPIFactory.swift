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
    func makeSearchAPIProvider() -> MoyaProvider<SearchAPI>
}
