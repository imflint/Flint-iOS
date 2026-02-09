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
    func fetchPopularContents() -> AnyPublisher<[ContentEntity], Error>
}

public class DefaultFetchPopularContentsUseCase: FetchPopularContentsUseCase {
    
    private let searchRepository: SearchRepository
    
    public init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
    }
    
    public func fetchPopularContents() -> AnyPublisher<[ContentEntity], Error> {
        return searchRepository.searchContents(keyword: nil)
    }
}
