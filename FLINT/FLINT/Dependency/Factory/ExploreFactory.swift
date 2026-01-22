//
//  ExploreFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

import Moya

import Data
import Domain
import Presentation

protocol ExploreFactory {
    func makeCollectionAPIProvider() -> MoyaProvider<CollectionAPI>
    
    func makeCollectionService() -> CollectionService
    func makeCollectionService(exploreAPIProvider: MoyaProvider<CollectionAPI>) -> CollectionService
    
    func makeCollectionRepository() -> CollectionRepository
    func makeCollectionRepository(collectionService: CollectionService) -> CollectionRepository
    
    func makeExploreUseCase() -> ExploreUseCase
    func makeExploreUseCase(collectionRepository: CollectionRepository) -> ExploreUseCase
    
    func makeExploreViewModel() -> ExploreViewModel
    func makeExploreViewModel(exploreUseCase: ExploreUseCase) -> ExploreViewModel
}

extension ExploreFactory {
    func makeCollectionService() -> CollectionService {
        return makeCollectionService(exploreAPIProvider: makeCollectionAPIProvider())
    }
    func makeCollectionService(exploreAPIProvider: MoyaProvider<CollectionAPI>) -> CollectionService {
        return DefaultCollectionService(provider: exploreAPIProvider)
    }
    
    func makeCollectionRepository() -> CollectionRepository {
        return makeCollectionRepository(collectionService: makeCollectionService())
    }
    func makeCollectionRepository(collectionService: CollectionService) -> CollectionRepository {
        return DefaultCollectionRepository(collectionService: collectionService)
    }
    
    func makeExploreUseCase() -> ExploreUseCase {
        return makeExploreUseCase(collectionRepository: makeCollectionRepository())
    }
    func makeExploreUseCase(collectionRepository: CollectionRepository) -> ExploreUseCase {
        return DefaultExploreUseCase(collectionRepository: collectionRepository)
    }
    
    func makeExploreViewModel() -> ExploreViewModel {
        return makeExploreViewModel(exploreUseCase: makeExploreUseCase())
    }
    func makeExploreViewModel(exploreUseCase: ExploreUseCase) -> ExploreViewModel {
        return DefaultExploreViewModel(exploreUseCase: exploreUseCase)
    }
}
