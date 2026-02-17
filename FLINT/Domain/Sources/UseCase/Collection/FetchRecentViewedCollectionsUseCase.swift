//
//  FetchRecentViewedCollectionsUseCase.swift
//  Domain
//
//  Created by 소은 on 1/24/26.
//

import Combine
import Foundation

import Entity
import Repository

public protocol FetchRecentViewedCollectionsUseCase {
    func callAsFunction() -> AnyPublisher<[CollectionEntity], Error>
}

public final class DefaultFetchRecentViewedCollectionsUseCase: FetchRecentViewedCollectionsUseCase {
    
    private let collectionRepository: CollectionRepository
    
    public init(collectionRepository: CollectionRepository) {
        self.collectionRepository = collectionRepository
    }
    
    public func callAsFunction() -> AnyPublisher<[CollectionEntity], Error> {
        return collectionRepository.fetchRecentViewedCollections()
    }
}
