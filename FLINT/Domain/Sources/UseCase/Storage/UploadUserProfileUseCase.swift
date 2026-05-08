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
    func callAsFunction(_ image: UIImage) -> AnyPublisher<Void, Error>
}

public final class DefaultUploadUserProfileUseCase: UploadUserProfileUseCase {
    
    private let storageRepository: StorageRepository
    
    public init(storageRepository: StorageRepository) {
        self.storageRepository = storageRepository
    }
    
    public func callAsFunction(_ image: UIImage) -> AnyPublisher<Void, any Error> {
        storageRepository.fetchPresignedURL(uploadType: .userProfile, fileExtension: <#T##FileExtension#>)
    }
}
