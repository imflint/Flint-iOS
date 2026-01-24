//
//  WatchingCollections.swift
//  Domain
//
//  Created by 소은 on 1/24/26.
//

import Combine
import Foundation

import Entity
import Repository

public protocol FetchWatchingCollectionsUseCase {
    func fetchWatchingCollections() -> AnyPublisher<[CollectionEntity], Error>
}

public final class DefaultFetchWatchingCollectionsUseCase: FetchWatchingCollectionsUseCase {

    private let collectionRepository: CollectionRepository

    public init(collectionRepository: CollectionRepository) {
        self.collectionRepository = collectionRepository
    }

    public func fetchWatchingCollections() -> AnyPublisher<[CollectionEntity], Error> {
        collectionRepository.fetchWatchingCollections()
    }
}
