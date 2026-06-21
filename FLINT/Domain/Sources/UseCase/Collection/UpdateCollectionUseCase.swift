//
//  UpdateCollectionUseCase.swift
//  Domain
//
//  Created by 진소은 on 6/21/26.
//

import Combine
import Foundation

import Entity
import Repository

public protocol UpdateCollectionUseCase {
    func callAsFunction(collectionId: Int64, collectionInfo: CreateCollectionEntity) -> AnyPublisher<Void, Error>
}

public final class DefaultUpdateCollectionUseCase: UpdateCollectionUseCase {

    private let collectionRepository: CollectionRepository

    public init(collectionRepository: CollectionRepository) {
        self.collectionRepository = collectionRepository
    }

    public func callAsFunction(collectionId: Int64, collectionInfo: CreateCollectionEntity) -> AnyPublisher<Void, Error> {
        return collectionRepository.updateCollection(collectionId: collectionId, collectionInfo: collectionInfo)
    }
}
