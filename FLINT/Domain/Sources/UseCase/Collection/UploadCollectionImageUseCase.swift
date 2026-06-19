//
//  UploadCollectionImageUseCase.swift
//  Domain
//
//  Created by 소은 on 5/29/26.
//

import Combine
import Foundation
import UIKit

import Entity
import Repository

public protocol UploadCollectionImageUseCase {
    func callAsFunction(_ image: UIImage) -> AnyPublisher<String, Error>
}

public final class DefaultUploadCollectionImageUseCase: UploadCollectionImageUseCase {
    
    private let storageRepository: StorageRepository
    
    public init(storageRepository: StorageRepository) {
        self.storageRepository = storageRepository
    }
    
    public func callAsFunction(_ image: UIImage) -> AnyPublisher<String, any Error> {
        storageRepository.fetchPresignedURL(uploadType: .collectionContent, fileExtension: .png)
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
