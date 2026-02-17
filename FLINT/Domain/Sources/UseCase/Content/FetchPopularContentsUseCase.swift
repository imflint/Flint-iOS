//
//  FetchPopularContentsUseCase.swift
//  Domain
//
//  Created by 김호성 on 2026.01.22.
//

import Combine
import Foundation

import Entity
import Repository

public protocol FetchPopularContentsUseCase {
    func callAsFunction() -> AnyPublisher<[ContentEntity], Error>
}

public class DefaultFetchPopularContentsUseCase: FetchPopularContentsUseCase {
    
    private let searchRepository: SearchRepository
    
    public init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
    }
    
    public func callAsFunction() -> AnyPublisher<[ContentEntity], Error> {
        return searchRepository.searchContents(keyword: nil)
    }
}
