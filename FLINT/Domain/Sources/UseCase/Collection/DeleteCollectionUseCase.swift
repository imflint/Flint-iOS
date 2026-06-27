//
//  DeleteCollectionUseCase.swift
//  Domain
//
//  Created by 진소은 on 6/21/26.
//

import Combine
import Foundation

import Repository

public protocol DeleteCollectionUseCase {
    func callAsFunction(collectionId: Int64) -> AnyPublisher<Void, Error>
}

public final class DefaultDeleteCollectionUseCase: DeleteCollectionUseCase {

    private let collectionRepository: CollectionRepository

    public init(collectionRepository: CollectionRepository) {
        self.collectionRepository = collectionRepository
    }

    public func callAsFunction(collectionId: Int64) -> AnyPublisher<Void, Error> {
        return collectionRepository.deleteCollection(collectionId: collectionId)
    }
}
