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
    func fetchCollectionDetail(collectionId: Int64) -> AnyPublisher<CollectionDetailDTO.DataDTO, Error>
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
            .handleEvents(receiveOutput: { response in
                if response.statusCode == 404 {
                    let body = String(data: response.data, encoding: .utf8) ?? ""
                    print("❌ 404 body:", body)
                }
            })
            .eraseToAnyPublisher() 
            .extractData(CreateCollectionResponseDTO.self)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    public func fetchCollectionDetail(collectionId: Int64) -> AnyPublisher<CollectionDetailDTO.DataDTO, Error> {
        provider.requestPublisher(.fetchCollectionDetail(collectionId: collectionId))
            .extractData(CollectionDetailDTO.DataDTO.self)
    }
}

