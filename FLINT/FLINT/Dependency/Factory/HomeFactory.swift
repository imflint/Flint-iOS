//
//  HomeFactory.swift
//  FLINT
//

import Foundation
import Moya

import Data
import Domain
import Presentation

// MARK: - HomeFactory

protocol HomeFactory: ProfileFactory, CreateCollectionFactory {

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

    // MARK: - Watching Collections (Collection Swagger)

    // UseCase
    func makeFetchWatchingCollectionsUseCase() -> FetchWatchingCollectionsUseCase
    func makeFetchWatchingCollectionsUseCase(collectionRepository: CollectionRepository) -> FetchWatchingCollectionsUseCase

    // MARK: - ViewModel

    func makeHomeViewModel() -> HomeViewModel
    func makeHomeViewModel(
        homeUseCase: HomeUseCase,
        userProfileUseCase: UserProfileUseCase,
        fetchWatchingCollectionsUseCase: FetchWatchingCollectionsUseCase
    ) -> HomeViewModel
}

// MARK: - Default Implementations

extension HomeFactory {

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

    // MARK: - Watching Collections (Collection Swagger)

    func makeFetchWatchingCollectionsUseCase() -> FetchWatchingCollectionsUseCase {
        makeFetchWatchingCollectionsUseCase(collectionRepository: makeCollectionRepository())
    }

    func makeFetchWatchingCollectionsUseCase(collectionRepository: CollectionRepository) -> FetchWatchingCollectionsUseCase {
        DefaultFetchWatchingCollectionsUseCase(collectionRepository: collectionRepository)
    }

    // MARK: - ViewModel

    func makeHomeViewModel() -> HomeViewModel {
        makeHomeViewModel(
            homeUseCase: makeHomeUseCase(),
            userProfileUseCase: makeUserProfileUseCase(),
            fetchWatchingCollectionsUseCase: makeFetchWatchingCollectionsUseCase()
        )
    }

    func makeHomeViewModel(
        homeUseCase: HomeUseCase,
        userProfileUseCase: UserProfileUseCase,
        fetchWatchingCollectionsUseCase: FetchWatchingCollectionsUseCase
    ) -> HomeViewModel {
        HomeViewModel(
            homeUseCase: homeUseCase,
            userProfileUseCase: userProfileUseCase,
            fetchWatchingCollectionsUseCase: fetchWatchingCollectionsUseCase,
            initialUserName: "얀비"
        )
    }
}
