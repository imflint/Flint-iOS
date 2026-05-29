//
//  StorageAPIProviderFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.05.08.
//

import Foundation

import Moya

import Data

protocol StorageAPIProviderFactory {
    var storageAPIProvider: MoyaProvider<StorageAPI> { get set }
    
    func makeStorageAPIProvider() -> MoyaProvider<StorageAPI>
}

extension StorageAPIProviderFactory {
    func makeStorageAPIProvider() -> MoyaProvider<StorageAPI> {
        return storageAPIProvider
    }
}
