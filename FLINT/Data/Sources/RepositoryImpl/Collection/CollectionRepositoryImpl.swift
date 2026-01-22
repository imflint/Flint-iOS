//
//  CollectionRepositoryImpl.swift
//  Data
//
//  Created by 소은 on 1/20/26.
//

import Combine
import Foundation

import Domain

import DTO
import Networking

public final class DefaultCollectionRepositoryImpl: CollectionRepository {
    
    private let collectionService: CollectionService
    
    public init(collectionService: CollectionService) {
        self.collectionService = collectionService
    }
    
    public func createCollection(_ entity: CreateCollectionEntity) -> AnyPublisher<Void, Error> {
        return collectionService.createCollection(entity)
    }
}
