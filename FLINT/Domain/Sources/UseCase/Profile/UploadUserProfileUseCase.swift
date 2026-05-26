//
//  UploadUserProfileUseCase.swift
//  Domain
//
//  Created by 김호성 on 2026.05.01.
//

import Combine
import Foundation
import UIKit

import Entity
import Repository

public protocol UploadUserProfileUseCase {
    func callAsFunction(_ image: UIImage) -> AnyPublisher<String, Error>
}

public final class DefaultUploadUserProfileUseCase: UploadUserProfileUseCase {
    
    private let storageRepository: StorageRepository
    
    public init(storageRepository: StorageRepository) {
        self.storageRepository = storageRepository
    }
    
    public func callAsFunction(_ image: UIImage) -> AnyPublisher<String, any Error> {
        storageRepository.fetchPresignedURL(uploadType: .userProfile, fileExtension: .png)
            .flatMap { [storageRepository] presignedUrlInfoEntity in
                guard let imageData = image.pngData() else {
                    return Fail<String, Error>(error: FlintError.imageEncodingFailed).eraseToAnyPublisher()
                }
                return storageRepository.uploadImageToS3(imageData: imageData, uploadUrl: presignedUrlInfoEntity.uploadUrl, fileExtension: .png)
                    .map { _ in return presignedUrlInfoEntity.key }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
