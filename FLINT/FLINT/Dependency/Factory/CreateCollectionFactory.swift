//
//  CreateCollectionFactory.swift
//  FLINT
//

import Foundation
import Moya

import Data
import Domain
import Presentation

public protocol CreateCollectionFactory {

    // Root Dependency
    func makeCollectionAPIProvider() -> MoyaProvider<CollectionAPI>

    // Service
    func makeCollectionService() -> CollectionService
    func makeCollectionService(collectionAPIProvider: MoyaProvider<CollectionAPI>) -> CollectionService

    // Repository
    func makeCollectionRepository() -> CollectionRepository
    func makeCollectionRepository(collectionService: CollectionService) -> CollectionRepository

    // UseCase
    func makeCreateCollectionUseCase() -> CreateCollectionUseCase
    func makeCreateCollectionUseCase(collectionRepository: CollectionRepository) -> CreateCollectionUseCase

    // ViewModel
    func makeCreateCollectionViewModel() -> CreateCollectionViewModel
    func makeCreateCollectionViewModel(createCollectionUseCase: CreateCollectionUseCase) -> CreateCollectionViewModel
}

public extension CreateCollectionFactory {

    func makeCollectionService() -> CollectionService {
        return makeCollectionService(collectionAPIProvider: makeCollectionAPIProvider())
    }

    func makeCollectionService(collectionAPIProvider: MoyaProvider<CollectionAPI>) -> CollectionService {
        return DefaultCollectionService(provider: collectionAPIProvider)
    }

    func makeCollectionRepository() -> CollectionRepository {
        return makeCollectionRepository(collectionService: makeCollectionService())
    }

    func makeCollectionRepository(collectionService: CollectionService) -> CollectionRepository {
        return DefaultCollectionRepository(collectionService: collectionService)
    }

    func makeCreateCollectionUseCase() -> CreateCollectionUseCase {
        return makeCreateCollectionUseCase(collectionRepository: makeCollectionRepository())
    }

    func makeCreateCollectionUseCase(collectionRepository: CollectionRepository) -> CreateCollectionUseCase {
        return DefaultCreateCollectionUseCase(collectionRepository: collectionRepository)
    }

    func makeCreateCollectionViewModel() -> CreateCollectionViewModel {
        return CreateCollectionViewModel()
    }

    func makeCreateCollectionViewModel(createCollectionUseCase: CreateCollectionUseCase) -> CreateCollectionViewModel {
        return CreateCollectionViewModel()
    }
}
