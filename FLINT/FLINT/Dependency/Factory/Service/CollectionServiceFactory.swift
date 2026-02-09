//
//  CollectionServiceFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

import Moya

import Data

protocol CollectionServiceFactory: CollectionAPIProviderFactory {
    func makeCollectionService() -> CollectionService
    func makeCollectionService(collectionAPIProvider: MoyaProvider<CollectionAPI>) -> CollectionService
}

extension CollectionServiceFactory {
    func makeCollectionService() -> CollectionService {
        return makeCollectionService(collectionAPIProvider: makeCollectionAPIProvider())
    }
    func makeCollectionService(collectionAPIProvider: MoyaProvider<CollectionAPI>) -> CollectionService {
        return DefaultCollectionService(collectionAPIProvider: collectionAPIProvider)
    }
}
