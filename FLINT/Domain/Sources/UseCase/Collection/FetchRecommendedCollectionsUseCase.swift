//
//  FetchRecommendedCollectionsUseCase.swift
//  Domain
//
//  Created by 김호성 on 2026.02.08.
//

import Combine
import Foundation

import Entity
import Repository

public protocol FetchRecommendedCollectionsUseCase {
    func callAsFunction() -> AnyPublisher<[CollectionEntity], Error>
}

public final class DefaultFetchRecommendedCollectionsUseCase: FetchRecommendedCollectionsUseCase {
    
    private let homeRepository: HomeRepository
    
    public init(homeRepository: HomeRepository) {
        self.homeRepository = homeRepository
    }
    
    public func callAsFunction() -> AnyPublisher<[CollectionEntity], Error> {
        return homeRepository.fetchRecommendedCollections()
    }
}
