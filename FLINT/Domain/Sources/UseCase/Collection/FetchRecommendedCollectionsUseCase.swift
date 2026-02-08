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
    func fetchRecommendedCollections() -> AnyPublisher<[CollectionInfoEntity], Error>
}

public final class DefaultFetchRecommendedCollectionsUseCase: FetchRecommendedCollectionsUseCase {
    
    private let homeRepository: HomeRepository
    
    public init(homeRepository: HomeRepository) {
        self.homeRepository = homeRepository
    }
    
    public func fetchRecommendedCollections() -> AnyPublisher<[CollectionInfoEntity], Error> {
        return homeRepository.fetchRecommendedCollections()
    }
}
