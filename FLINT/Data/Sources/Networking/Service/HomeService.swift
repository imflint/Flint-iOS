//
//  HomeService.swift
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

public protocol HomeService {
    func fetchRecommendedCollections() -> AnyPublisher<[CollectionInfoEntity], Error>
}

public final class DefaultHomeService: HomeService {

    private let provider: MoyaProvider<HomeAPI>

    public init(provider: MoyaProvider<HomeAPI>) {
        self.provider = provider
    }

    public func fetchRecommendedCollections() -> AnyPublisher<[CollectionInfoEntity], Error> {
        return provider.requestPublisher(.fetchRecommendedCollections)
            .extractData(HomeRecommendedCollectionsDTO.self)
            .tryMap { try $0.entity }   
            .eraseToAnyPublisher()
    }
}
