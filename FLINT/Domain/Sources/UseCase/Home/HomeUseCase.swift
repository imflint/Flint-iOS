//
//  HomeUsecase.swift
//  Domain
//
//  Created by 소은 on 1/20/26.
//
import Combine
import Foundation

import Entity
import Repository

public protocol HomeUseCase {
    func fetchRecommendedCollections() -> AnyPublisher<[CollectionInfoEntity], Error>
}

public class DefaultHomeUseCase: HomeUseCase {
    
    private let homeRepository: HomeRepository
    
    public init(homeRepository: HomeRepository) {
        self.homeRepository = homeRepository
    }
    
    public func fetchRecommendedCollections() -> AnyPublisher<[CollectionInfoEntity], Error> {
        return homeRepository.fetchRecommendedCollections()
    }
}
