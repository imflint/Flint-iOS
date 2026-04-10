//
//  CollectionServiceFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

import Data

protocol CollectionServiceFactory: CollectionAPIProviderFactory {
    func makeCollectionService() -> CollectionService
}

extension CollectionServiceFactory {
    func makeCollectionService() -> CollectionService {
        return DefaultCollectionService(collectionAPIProvider: makeCollectionAPIProvider())
    }
}
