//
//  FetchPopularCollectionsUseCase.swift
//  Domain
//
//  Created by 소은 on 2026.06.08.
//

import Combine
import Foundation

import Entity
import Repository

public protocol FetchPopularCollectionsUseCase {
    func callAsFunction() -> AnyPublisher<[CollectionEntity], Error>
}

public final class DefaultFetchPopularCollectionsUseCase: FetchPopularCollectionsUseCase {
    
    private let homeRepository: HomeRepository
    
    public init(homeRepository: HomeRepository) {
        self.homeRepository = homeRepository
    }
    
    public func callAsFunction() -> AnyPublisher<[CollectionEntity], Error> {
        return homeRepository.fetchPopularCollections()
    }
}
