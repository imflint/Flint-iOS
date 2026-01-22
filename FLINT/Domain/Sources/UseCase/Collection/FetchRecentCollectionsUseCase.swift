//
//  FetchRecentCollections.swift
//  Domain
//
//  Created by 소은 on 1/22/26.
//

import Combine
import Foundation

import Entity
import Repository

public protocol FetchRecentCollectionsUseCase {
    func fetchRecentCollections() -> AnyPublisher<[RecentCollectionEntity], Error>
}

public final class DefaultRecentCollectionUseCase: FetchRecentCollectionsUseCase {
    
    private let repository: CollectionRepository
    
    public init(repository: CollectionRepository) {
        self.repository = repository
    }
    
    public func fetchRecentCollections() -> AnyPublisher<[RecentCollectionEntity], Error> {
        repository.fetchRecentCollections()
    }
}
