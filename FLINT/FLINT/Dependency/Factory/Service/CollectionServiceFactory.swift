//
//  File.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

import Moya

import Data

protocol CollectionServiceFactory: CollectionAPIFactory {
    func makeCollectionService() -> CollectionService
    func makeCollectionService(exploreAPIProvider: MoyaProvider<CollectionAPI>) -> CollectionService
}

extension CollectionServiceFactory {
    func makeCollectionService() -> CollectionService {
        return makeCollectionService(exploreAPIProvider: makeCollectionAPIProvider())
    }
    func makeCollectionService(exploreAPIProvider: MoyaProvider<CollectionAPI>) -> CollectionService {
        return DefaultCollectionService(provider: exploreAPIProvider)
    }
}
