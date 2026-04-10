//
//  FetchCollectionDetailUseCase.swift
//  Domain
//
//  Created by 진소은 on 1/23/26.
//

import Combine
import Foundation

import Entity
import Repository

public protocol FetchCollectionDetailUseCase {
    func callAsFunction(collectionId: Int64) -> AnyPublisher<CollectionDetailEntity, Error>
}

public class DefaultFetchCollectionDetailUseCase: FetchCollectionDetailUseCase {
    
    private let collectionRepository: CollectionRepository
    
    public init(collectionRepository: CollectionRepository) {
        self.collectionRepository = collectionRepository
    }
    
    public func callAsFunction(collectionId: Int64) -> AnyPublisher<CollectionDetailEntity, Error> {
        return collectionRepository.fetchCollectionDetail(collectionId: collectionId)
    }
}
