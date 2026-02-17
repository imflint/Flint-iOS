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
    func callAsFunction(collectionInfo: CreateCollectionEntity) -> AnyPublisher<Int64, Error>
}

public class DefaultCreateCollectionUseCase: CreateCollectionUseCase {
    
    private let collectionRepository: CollectionRepository
    
    public init(collectionRepository: CollectionRepository) {
        self.collectionRepository = collectionRepository
    }
    
    public func callAsFunction(collectionInfo: CreateCollectionEntity) -> AnyPublisher<Int64, Error> {
        return collectionRepository.createCollection(collectionInfo: collectionInfo)
    }
}
