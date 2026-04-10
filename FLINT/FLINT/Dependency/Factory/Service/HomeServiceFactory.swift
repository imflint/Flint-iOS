//
//  HomeServiceFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.31.
//

import Foundation

import Data

protocol HomeServiceFactory: HomeAPIProviderFactory {
    func makeHomeService() -> HomeService
}

extension HomeServiceFactory {
    func makeHomeService() -> HomeService {
        return DefaultHomeService(homeAPIProvider: makeHomeAPIProvider())
    }
}
