//
//  CollectionDetailUseCase.swift
//  Domain
//
//  Created by 진소은 on 1/23/26.
//

import Combine
import Foundation

import Entity
import Repository

public protocol CollectionDetailUseCase {
    func fetchCollectionDetail(collectionId: Int64) -> AnyPublisher<CollectionDetailEntity, Error>
}

public class DefaultCollectionDetailUseCase: CollectionDetailUseCase {

    private let collectionRepository: CollectionRepository

    public init(collectionRepository: CollectionRepository) {
        self.collectionRepository = collectionRepository
    }

    public func fetchCollectionDetail(collectionId: Int64) -> AnyPublisher<CollectionDetailEntity, Error> {
        return collectionRepository.fetchCollectionDetail(collectionId: collectionId)
    }
}
