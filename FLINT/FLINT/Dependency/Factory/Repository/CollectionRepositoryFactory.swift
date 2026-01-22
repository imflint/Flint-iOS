//
//  File.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

import Data
import Domain

protocol CollectionRepositoryFactory: CollectionServiceFactory {
    func makeCollectionRepository() -> CollectionRepository
    func makeCollectionRepository(collectionService: CollectionService) -> CollectionRepository
}

extension CollectionRepositoryFactory {
    func makeCollectionRepository() -> CollectionRepository {
        return makeCollectionRepository(collectionService: makeCollectionService())
    }
    func makeCollectionRepository(collectionService: CollectionService) -> CollectionRepository {
        return DefaultCollectionRepository(collectionService: collectionService)
    }
}
