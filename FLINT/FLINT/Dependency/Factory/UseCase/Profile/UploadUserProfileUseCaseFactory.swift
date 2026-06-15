//
//  UploadUserProfileUseCaseFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.05.08.
//

import Foundation

import Domain

protocol UploadUserProfileUseCaseFactory: StorageRepositoryFactory {
    func makeUploadUserProfileUseCase() -> UploadUserProfileUseCase
}

extension UploadUserProfileUseCaseFactory {
    func makeUploadUserProfileUseCase() -> UploadUserProfileUseCase {
        return DefaultUploadUserProfileUseCase(storageRepository: makeStorageRepository())
    }
}
