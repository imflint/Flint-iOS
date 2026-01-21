//
//  CreateCollectionUseCase.swift
//  Domain
//
//  Created by 소은 on 1/20/26.
//

import Combine
import Foundation

import Entity
import Repository

public protocol CreateCollectionUseCase {
    func createCollection(_ entity: CreateCollectionEntity) -> AnyPublisher<Void, NetworkError>
}

public class DefaultCreateCollectionUseCase: CreateCollectionUseCase {
    
    private let collectionRepository: CollectionRepository
    
    public init(collectionRepository: CollectionRepository) {
        self.collectionRepository = collectionRepository
    }
    
    public func createCollection(_ entity: CreateCollectionEntity) -> AnyPublisher<Void, NetworkError> {
        return collectionRepository.createCollection(entity)
    }
}
