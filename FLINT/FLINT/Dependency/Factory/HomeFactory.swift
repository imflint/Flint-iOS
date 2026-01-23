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

    // MARK: - Home (Recommended)

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

    // MARK: - ViewModel

    func makeHomeViewModel() -> HomeViewModel
    func makeHomeViewModel(homeUseCase: HomeUseCase) -> HomeViewModel
}

public extension HomeFactory {

    // MARK: - Home (Recommended)

    func makeHomeService() -> HomeService {
        makeHomeService(homeAPIProvider: makeHomeAPIProvider())
    }

    func makeHomeService(homeAPIProvider: MoyaProvider<HomeAPI>) -> HomeService {
        DefaultHomeService(provider: homeAPIProvider)
    }

    func makeHomeRepository() -> HomeRepository {
        makeHomeRepository(homeService: makeHomeService())
    }

    func makeHomeRepository(homeService: HomeService) -> HomeRepository {
        DefaultHomeRepository(homeService: homeService)
    }

    func makeHomeUseCase() -> HomeUseCase {
        makeHomeUseCase(homeRepository: makeHomeRepository())
    }

    func makeHomeUseCase(homeRepository: HomeRepository) -> HomeUseCase {
        DefaultHomeUseCase(homeRepository: homeRepository)
    }

    // MARK: - ViewModel

    func makeHomeViewModel() -> HomeViewModel {
        makeHomeViewModel(
            homeUseCase: makeHomeUseCase()
        )
    }
    
    func makeHomeViewModel(homeUseCase: HomeUseCase) -> HomeViewModel {
            HomeViewModel(homeUseCase: homeUseCase, initialUserName: "안비")
    }
}

