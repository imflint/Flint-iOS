//
//  UploadCollectionImageUseCaseFactory.swift
//  FLINT
//
//  Created by 소은 on 2026.05.29.
//

import Foundation

import Domain

protocol UploadCollectionImageUseCaseFactory: StorageRepositoryFactory {
    func makeUploadCollectionImageUseCase() -> UploadCollectionImageUseCase
}

extension UploadCollectionImageUseCaseFactory {
    func makeUploadCollectionImageUseCase() -> UploadCollectionImageUseCase {
        return DefaultUploadCollectionImageUseCase(storageRepository: makeStorageRepository())
    }
}
