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
    func fetchCollections(cursor: UInt?, size: Int) -> AnyPublisher<CollectionPagingEntity, Error>
    func createCollection(_ entity: CreateCollectionEntity) -> AnyPublisher<Void, Error>
    func fetchCollectionDetail(collectionId: Int64) -> AnyPublisher<CollectionDetailEntity, Error>
}
