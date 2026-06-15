//
//  StorageServiceFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.05.08.
//

import Foundation

import Data

protocol StorageServiceFactory: StorageAPIProviderFactory {
    func makeStorageService() -> StorageService
}

extension StorageServiceFactory {
    func makeStorageService() -> StorageService {
        return DefaultStorageService(storageAPIProvider: makeStorageAPIProvider())
    }
}
