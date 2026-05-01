//
//  StorageRepository.swift
//  Domain
//
//  Created by 김호성 on 2026.05.01.
//

import Combine
import Foundation

import Entity

public protocol StorageRepository {
    func fetchPresignedURL(uploadType: UploadType, fileExtension: FileExtension) -> AnyPublisher<PresignedUrlInfoEntity, Error>
}
