//
//  HomeRepositoryFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.02.
//

import Foundation

import Data
import Domain

protocol HomeRepositoryFactory: HomeServiceFactory {
    func makeHomeRepository() -> HomeRepository
}

extension HomeRepositoryFactory {
    func makeHomeRepository() -> HomeRepository {
        return DefaultHomeRepository(homeService: makeHomeService())
    }
}
