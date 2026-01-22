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
    func createCollection(_ entity: CreateCollectionEntity) -> AnyPublisher<Void, Error>
    func fetchRecentCollections() -> AnyPublisher<RecentCollectionsDTO, Error>
}

public final class DefaultCollectionService: CollectionService {
    private let provider: MoyaProvider<CollectionAPI>
    
    public init(provider: MoyaProvider<CollectionAPI>) {
        self.provider = provider
    }
    
    public func createCollection(_ entity: CreateCollectionEntity) -> AnyPublisher<Void, Error> {
        return provider.requestPublisher(.createCollection(entity))
            .extractData(BlankData.self)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    
    public func fetchRecentCollections() -> AnyPublisher<RecentCollectionsDTO, Error> {
        provider.requestPublisher(.fetchRecentCollections)
            .extractData(RecentCollectionsDTO.self)
            .eraseToAnyPublisher()
    }
}

