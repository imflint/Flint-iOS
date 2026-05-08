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
    private let presignedUrlService: PresignedUrlService
    
    public init(storageService: StorageService, presignedUrlService: PresignedUrlService) {
        self.storageService = storageService
        self.presignedUrlService = presignedUrlService
    }
    
    public func fetchPresignedURL(uploadType: UploadType, fileExtension: FileExtension) -> AnyPublisher<PresignedUrlInfoEntity, any Error> {
        return storageService.fetchpresignedUrl(uploadType: uploadType, fileExtension: fileExtension)
            .tryMap({ try $0.presignedUrlInfoEntity })
            .eraseToAnyPublisher()
    }
    
    public func uploadImageToS3(imageData: Data, uploadUrl: URL, fileExtension: FileExtension) -> AnyPublisher<Void, Error> {
        return presignedUrlService.uploadImageToS3(imageData: imageData, uploadUrl: uploadUrl, fileExtension: fileExtension)
    }
}
