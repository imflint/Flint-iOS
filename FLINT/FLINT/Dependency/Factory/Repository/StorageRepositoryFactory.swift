//
//  StorageRepositoryFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.05.08.
//

import Foundation

import Data
import Domain

protocol StorageRepositoryFactory: StorageServiceFactory, PresignedUrlServiceFactory {
    func makeStorageRepository() -> StorageRepository
}

extension StorageRepositoryFactory {
    func makeStorageRepository() -> StorageRepository {
        return DefaultStorageRepository(storageService: makeStorageService(), presignedUrlService: makePresignedUrlService())
    }
}
