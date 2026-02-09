//
//  FetchCollectionsUseCase.swift
//  Domain
//
//  Created by 김호성 on 2026.01.22.
//

import Combine
import Foundation

import Entity
import Repository

public protocol FetchCollectionsUseCase {
    func fetchExplore(cursor: Int64?) -> AnyPublisher<CollectionPagingEntity, Error>
}

public final class DefaultFetchCollectionsUseCase: FetchCollectionsUseCase {
    
    private let collectionRepository: CollectionRepository
    
    public init(collectionRepository: CollectionRepository) {
        self.collectionRepository = collectionRepository
    }
    
    public func fetchExplore(cursor: Int64?) -> AnyPublisher<CollectionPagingEntity, Error> {
        collectionRepository.fetchCollections(cursor: cursor, size: 3)
    }
}
