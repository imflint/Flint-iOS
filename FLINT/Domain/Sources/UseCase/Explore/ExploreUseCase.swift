//
//  File.swift
//  Domain
//
//  Created by 김호성 on 2026.01.22.
//

import Combine
import Foundation

import Entity
import Repository

public protocol ExploreUseCase {
    func fetchExplore(cursor: UInt?) -> AnyPublisher<CollectionPagingEntity, Error>
}

public final class DefaultExploreUseCase: ExploreUseCase {
    
    private let collectionRepository: CollectionRepository
    
    public init(collectionRepository: CollectionRepository) {
        self.collectionRepository = collectionRepository
    }
    
    public func fetchExplore(cursor: UInt?) -> AnyPublisher<Entity.CollectionPagingEntity, any Error> {
        collectionRepository.fetchCollections(cursor: cursor, size: 3)
    }
}
