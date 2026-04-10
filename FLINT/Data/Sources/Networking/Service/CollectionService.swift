//
//  CollectionService.swift
//  Data
//
//  Created by 소은 on 1/20/26.
//

import Combine
import Foundation

import CombineMoya
import Moya

import Domain

import DTO

public protocol CollectionService {
    func fetchCollections(cursor: Int64?, size: Int32) -> AnyPublisher<PagedCollectionsDTO, Error>
    func createCollection(collectionInfo: CreateCollectionEntity) -> AnyPublisher<CreateCollectionDTO, Error>
    func fetchCollectionDetail(collectionId: Int64) -> AnyPublisher<CollectionDetailDTO, Error>
    func fetchRecentViewedCollections() -> AnyPublisher<CollectionsDTO, Error>
}

public final class DefaultCollectionService: CollectionService {
    private let collectionAPIProvider: MoyaProvider<CollectionAPI>
    
    public init(collectionAPIProvider: MoyaProvider<CollectionAPI>) {
        self.collectionAPIProvider = collectionAPIProvider
    }
    
    public func fetchCollections(cursor: Int64?, size: Int32) -> AnyPublisher<PagedCollectionsDTO, Error> {
        return collectionAPIProvider.requestPublisher(.fetchCollections(cursor: cursor, size: size))
            .mapBaseResponseData(PagedCollectionsDTO.self)
    }
    
    public func createCollection(collectionInfo: CreateCollectionEntity) -> AnyPublisher<CreateCollectionDTO, Error> {
        return collectionAPIProvider.requestPublisher(.createCollection(collectionInfo: collectionInfo))
            .mapBaseResponseData(CreateCollectionDTO.self)
    }
    
    public func fetchCollectionDetail(collectionId: Int64) -> AnyPublisher<CollectionDetailDTO, Error> {
        return collectionAPIProvider.requestPublisher(.fetchCollectionDetail(collectionId: collectionId))
            .mapBaseResponseData(CollectionDetailDTO.self)
    }
    
    public func fetchRecentViewedCollections() -> AnyPublisher<CollectionsDTO, Error> {
        return collectionAPIProvider.requestPublisher(.fetchRecentViewedCollections)
            .mapBaseResponseData(CollectionsDTO.self)
    }
}
