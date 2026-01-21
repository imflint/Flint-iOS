//
//  HomeRecommendedCollections.swift
//  Data
//
//  Created by 소은 on 1/20/26.
//

import Combine
import Foundation

import Domain

import DTO
import Networking

public final class DefaultHomeRepository: HomeRepository {
    
    private let homeService: HomeService
    
    public init(homeService: HomeService) {
        self.homeService = homeService
    }
    
    public func fetchRecommendedCollections() -> AnyPublisher<HomeRecommendedCollectionsEntity, NetworkError> {
        homeService.fetchRecommendedCollections()
            .map(\.entity)
            .eraseToAnyPublisher()
    }
}
