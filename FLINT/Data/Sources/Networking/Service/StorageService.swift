//
//  File.swift
//  Data
//
//  Created by 김호성 on 2026.05.01.
//

import Combine
import Foundation

import CombineMoya
import Moya

import Domain

import DTO

public protocol StorageService {
    func fetchpresignedUrl(uploadType: UploadType, fileExtension: FileExtension) -> AnyPublisher<StorageResponseDTO, Error>
}

public final class DefaultStorageService: StorageService {
    
    private let storageAPIProvider: MoyaProvider<StorageAPI>
    
    public init(storageAPIProvider: MoyaProvider<StorageAPI>) {
        self.storageAPIProvider = storageAPIProvider
    }
    
    public func fetchpresignedUrl(uploadType: UploadType, fileExtension: FileExtension) -> AnyPublisher<StorageResponseDTO, any Error> {
        return storageAPIProvider.requestPublisher(.fetchpresignedUrl(pathType: uploadType, fileExtension: fileExtension))
            .map(StorageResponseDTO.self)
            .mapError({ $0 as Error })
            .eraseToAnyPublisher()
    }
    
}
