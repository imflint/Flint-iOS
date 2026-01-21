//
//  HomeFactory.swift
//  FLINT
//

import Foundation
import Moya

import Data
import Domain
import Presentation

public protocol HomeFactory {

    // Root Dependency
    func makeHomeAPIProvider() -> MoyaProvider<HomeAPI>

    // Service
    func makeHomeService() -> HomeService
    func makeHomeService(homeAPIProvider: MoyaProvider<HomeAPI>) -> HomeService

    // Repository
    func makeHomeRepository() -> HomeRepository
    func makeHomeRepository(homeService: HomeService) -> HomeRepository

    // UseCase
    func makeHomeUseCase() -> HomeUseCase
    func makeHomeUseCase(homeRepository: HomeRepository) -> HomeUseCase

    // ViewModel
    func makeHomeViewModel(userName: String) -> HomeViewModelType
    func makeHomeViewModel(userName: String, homeUseCase: HomeUseCase) -> HomeViewModelType
}

public extension HomeFactory {

    func makeHomeService() -> HomeService {
        return makeHomeService(homeAPIProvider: makeHomeAPIProvider())
    }

    func makeHomeService(homeAPIProvider: MoyaProvider<HomeAPI>) -> HomeService {
        return DefaultHomeService(provider: homeAPIProvider)
    }

    func makeHomeRepository() -> HomeRepository {
        return makeHomeRepository(homeService: makeHomeService())
    }

    func makeHomeRepository(homeService: HomeService) -> HomeRepository {
        return DefaultHomeRepository(homeService: homeService)
    }

    func makeHomeUseCase() -> HomeUseCase {
        return makeHomeUseCase(homeRepository: makeHomeRepository())
    }

    func makeHomeUseCase(homeRepository: HomeRepository) -> HomeUseCase {
        return DefaultHomeUseCase(homeRepository: homeRepository)
    }

    func makeHomeViewModel(userName: String) -> HomeViewModelType {
        return makeHomeViewModel(userName: userName, homeUseCase: makeHomeUseCase())
    }

    func makeHomeViewModel(userName: String, homeUseCase: HomeUseCase) -> HomeViewModelType {
        return DefaultHomeViewModel(userName: userName, homeUseCase: homeUseCase)
    }
}
