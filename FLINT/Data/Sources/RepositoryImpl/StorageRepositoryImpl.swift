//
//  StorageRepositoryImpl.swift
//  Data
//
//  Created by 김호성 on 2026.05.01.
//

import Combine
import Foundation

import Domain

import DTO
import Networking

public final class DefaultStorageRepository: StorageRepository {
    
    private let storageService: StorageService
    
    public init(storageService: StorageService) {
        self.storageService = storageService
    }
    
    public func fetchPresignedURL(uploadType: UploadType, fileExtension: FileExtension) -> AnyPublisher<PresignedUrlInfoEntity, any Error> {
        return storageService.fetchpresignedUrl(uploadType: uploadType, fileExtension: fileExtension)
            .tryMap({ try $0.presignedUrlInfoEntity })
            .eraseToAnyPublisher()
    }
}
