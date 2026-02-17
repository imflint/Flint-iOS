//
//  CollectionRepositoryFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

import Data
import Domain

protocol CollectionRepositoryFactory: CollectionServiceFactory {
    func makeCollectionRepository() -> CollectionRepository
}

extension CollectionRepositoryFactory {
    func makeCollectionRepository() -> CollectionRepository {
        return DefaultCollectionRepository(collectionService: makeCollectionService())
    }
}
