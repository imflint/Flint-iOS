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

    // MARK: - Collection (Recent)

    // Root Dependency
    func makeCollectionAPIProvider() -> MoyaProvider<CollectionAPI>

    // Service
    func makeCollectionService() -> CollectionService
    func makeCollectionService(collectionAPIProvider: MoyaProvider<CollectionAPI>) -> CollectionService

    // Repository
    func makeCollectionRepository() -> CollectionRepository
    func makeCollectionRepository(collectionService: CollectionService) -> CollectionRepository

    // UseCase
    func makeFetchRecentCollectionsUseCase() -> FetchRecentCollectionsUseCase
    func makeFetchRecentCollectionsUseCase(collectionRepository: CollectionRepository) -> FetchRecentCollectionsUseCase

    // MARK: - ViewModel

    func makeHomeViewModel() -> HomeViewModel
    func makeHomeViewModel(homeUseCase: HomeUseCase, fetchRecentCollectionsUseCase: FetchRecentCollectionsUseCase) -> HomeViewModel
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

    // MARK: - Collection (Recent)

    func makeCollectionService() -> CollectionService {
        makeCollectionService(collectionAPIProvider: makeCollectionAPIProvider())
    }

    func makeCollectionService(collectionAPIProvider: MoyaProvider<CollectionAPI>) -> CollectionService {
        DefaultCollectionService(provider: collectionAPIProvider)
    }

    func makeCollectionRepository() -> CollectionRepository {
        makeCollectionRepository(collectionService: makeCollectionService())
    }

    func makeCollectionRepository(collectionService: CollectionService) -> CollectionRepository {
        DefaultCollectionRepository(collectionService: collectionService)
    }

    func makeFetchRecentCollectionsUseCase() -> FetchRecentCollectionsUseCase {
        makeFetchRecentCollectionsUseCase(collectionRepository: makeCollectionRepository())
    }

    func makeFetchRecentCollectionsUseCase(collectionRepository: CollectionRepository) -> FetchRecentCollectionsUseCase {
        DefaultRecentCollectionUseCase(repository: collectionRepository)
    }

    // MARK: - ViewModel

    func makeHomeViewModel() -> HomeViewModel {
        makeHomeViewModel(
            homeUseCase: makeHomeUseCase(),
            fetchRecentCollectionsUseCase: makeFetchRecentCollectionsUseCase()
        )
    }

    func makeHomeViewModel(
        homeUseCase: HomeUseCase,
        fetchRecentCollectionsUseCase: FetchRecentCollectionsUseCase
    ) -> HomeViewModel {
        DefaultHomeViewModel(
            homeUseCase: homeUseCase,
            fetchRecentCollectionsUseCase: fetchRecentCollectionsUseCase
        )
    }
}
