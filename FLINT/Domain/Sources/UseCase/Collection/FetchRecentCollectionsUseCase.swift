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
    func fetchRecentCollections() -> AnyPublisher<RecentCollectionsEntity, Error>
}

public final class DefaultFetchRecentCollectionsUseCase: FetchRecentCollectionsUseCase {

    private let collectionRepository: CollectionRepository

    public init(collectionRepository: CollectionRepository) {
        self.collectionRepository = collectionRepository
    }

    public func fetchRecentCollections() -> AnyPublisher<RecentCollectionsEntity, Error> {
        return collectionRepository.fetchRecentCollections()
    }
}
