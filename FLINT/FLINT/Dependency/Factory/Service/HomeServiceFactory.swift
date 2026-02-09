//
//  HomeServiceFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.31.
//

import Foundation

import Moya

import Data

protocol HomeServiceFactory: HomeAPIProviderFactory {
    func makeHomeService() -> HomeService
    func makeHomeService(homeAPIProvider: MoyaProvider<HomeAPI>) -> HomeService
}

extension HomeServiceFactory {
    func makeHomeService() -> HomeService {
        return makeHomeService(homeAPIProvider: makeHomeAPIProvider())
    }
    func makeHomeService(homeAPIProvider: MoyaProvider<HomeAPI>) -> HomeService {
        return DefaultHomeService(homeAPIProvider: homeAPIProvider)
    }
}
