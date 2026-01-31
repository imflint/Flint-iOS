//
//  CollectionAPIFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

import Moya

import Data

protocol CollectionAPIFactory {
    var collectionAPIProvider: MoyaProvider<CollectionAPI> { get set }
    
    func makeCollectionAPIProvider() -> MoyaProvider<CollectionAPI>
}

extension CollectionAPIFactory {
    func makeCollectionAPIProvider() -> MoyaProvider<CollectionAPI> {
        return collectionAPIProvider
    }
}
