//
//  CollectionRepository.swift
//  Domain
//
//  Created by 소은 on 1/20/26.
//

import Combine
import Foundation

import Entity

public protocol CollectionRepository {
    func fetchCollections(cursor: Int64?, size: Int32) -> AnyPublisher<CollectionPagingEntity, Error>
    func createCollection(collectionInfo: CreateCollectionEntity) -> AnyPublisher<Int64, Error>
    func updateCollection(collectionId: Int64, collectionInfo: CreateCollectionEntity) -> AnyPublisher<Void, Error>
    func deleteCollection(collectionId: Int64) -> AnyPublisher<Void, Error>
    func fetchCollectionDetail(collectionId: Int64) -> AnyPublisher<CollectionDetailEntity, Error>
    func fetchRecentViewedCollections() -> AnyPublisher<[CollectionEntity], Error>
}
