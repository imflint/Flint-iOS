//
//  FetchExploreCollectionsUseCase.swift
//  Domain
//
//  Created by 김호성 on 2026.01.22.
//

import Combine
import Foundation

import Entity
import Repository

public protocol FetchExploreCollectionsUseCase {
    func fetchExploreCollections(cursor: Int64?) -> AnyPublisher<CollectionPagingEntity, Error>
}

public final class DefaultFetchExploreCollectionsUseCase: FetchExploreCollectionsUseCase {
    
    private let collectionRepository: CollectionRepository
    
    public init(collectionRepository: CollectionRepository) {
        self.collectionRepository = collectionRepository
    }
    
    public func fetchExploreCollections(cursor: Int64?) -> AnyPublisher<CollectionPagingEntity, Error> {
        collectionRepository.fetchCollections(cursor: cursor, size: 3)
    }
}
