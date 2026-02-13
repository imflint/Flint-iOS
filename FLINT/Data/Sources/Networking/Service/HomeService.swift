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

import DTO

public protocol HomeService {
    func fetchRecommendedCollections() -> AnyPublisher<CollectionsDTO, Error>
}

public final class DefaultHomeService: HomeService {
    
    private let homeAPIProvider: MoyaProvider<HomeAPI>
    
    public init(homeAPIProvider: MoyaProvider<HomeAPI>) {
        self.homeAPIProvider = homeAPIProvider
    }
    
    public func fetchRecommendedCollections() -> AnyPublisher<CollectionsDTO, Error> {
        return homeAPIProvider.requestPublisher(.fetchRecommendedCollections)
            .mapBaseResponseData(CollectionsDTO.self)
    }
}

