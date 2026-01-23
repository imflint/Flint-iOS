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
    func fetchCollections(cursor: UInt?, size: Int) -> AnyPublisher<CollectionsDTO, Error>
    func createCollection(_ entity: CreateCollectionEntity) -> AnyPublisher<Void, Error>
}

public final class DefaultCollectionService: CollectionService {
    private let provider: MoyaProvider<CollectionAPI>
    
    public init(provider: MoyaProvider<CollectionAPI>) {
        self.provider = provider
    }
    
    public func fetchCollections(cursor: UInt?, size: Int) -> AnyPublisher<CollectionsDTO, Error> {
        return provider.requestPublisher(.fetchCollections(cursor: cursor, size: size))
            .extractData(CollectionsDTO.self)
    }
    
    public func createCollection(_ entity: CreateCollectionEntity) -> AnyPublisher<Void, Error> {
        return provider.requestPublisher(.createCollection(entity))
            .extractData(BlankData.self)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}

