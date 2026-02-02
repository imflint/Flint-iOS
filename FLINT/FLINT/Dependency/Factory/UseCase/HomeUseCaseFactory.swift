//
//  HomeUseCaseFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.02.
//

import Foundation

import Domain

protocol HomeUseCaseFactory: HomeRepositoryFactory {
    func makeHomeUseCase() -> HomeUseCase
    func makeHomeUseCase(homeRepository: HomeRepository) -> HomeUseCase
}

extension HomeUseCaseFactory {
    func makeHomeUseCase() -> HomeUseCase {
        return makeHomeUseCase(homeRepository: makeHomeRepository())
    }
    func makeHomeUseCase(homeRepository: HomeRepository) -> HomeUseCase {
        return DefaultHomeUseCase(homeRepository: homeRepository)
    }
}
