//
//  SearchFactory.swift
//  FLINT
//
//  Created by 소은 on 1/22/26.
//

import Foundation

import Moya

import Data
import Domain
import Presentation

protocol SearchFactory {

    // Root Dependency
    func makeSearchAPIProvider() -> MoyaProvider<SearchAPI>

    // Service
    func makeSearchService() -> SearchService
    func makeSearchService(searchAPIProvider: MoyaProvider<SearchAPI>) -> SearchService

    // Repository
    func makeSearchRepository() -> SearchRepository
    func makeSearchRepository(searchService: SearchService) -> SearchRepository

    // UseCase
    func makeSearchContentsUseCase() -> SearchContentsUseCase
    func makeSearchContentsUseCase(searchRepository: SearchRepository) -> SearchContentsUseCase

    // ViewModel (AddContentSelect 전용)
    func makeAddContentSelectViewModel() -> AddContentSelectViewModel
    func makeAddContentSelectViewModel(searchContentsUseCase: SearchContentsUseCase) -> AddContentSelectViewModel
}

extension SearchFactory {

    // MARK: - Service

    func makeSearchService() -> SearchService {
        return makeSearchService(searchAPIProvider: makeSearchAPIProvider())
    }

    func makeSearchService(searchAPIProvider: MoyaProvider<SearchAPI>) -> SearchService {
        return DefaultSearchService(provider: searchAPIProvider)
    }

    // MARK: - Repository

    func makeSearchRepository() -> SearchRepository {
        return makeSearchRepository(searchService: makeSearchService())
    }

    func makeSearchRepository(searchService: SearchService) -> SearchRepository {
        return DefaultSearchRepository(searchService: searchService)
    }

    // MARK: - UseCase

    func makeSearchContentsUseCase() -> SearchContentsUseCase {
        return makeSearchContentsUseCase(searchRepository: makeSearchRepository())
    }

    func makeSearchContentsUseCase(searchRepository: SearchRepository) -> SearchContentsUseCase {
        return DefaultSearchContentsUseCase(repository: searchRepository)
    }

    // MARK: - ViewModel

    func makeAddContentSelectViewModel() -> AddContentSelectViewModel {
        return makeAddContentSelectViewModel(searchContentsUseCase: makeSearchContentsUseCase())
    }

    func makeAddContentSelectViewModel(searchContentsUseCase: SearchContentsUseCase) -> AddContentSelectViewModel {
        return DefaultAddContentSelectViewModel(useCase: searchContentsUseCase)
    }
}
