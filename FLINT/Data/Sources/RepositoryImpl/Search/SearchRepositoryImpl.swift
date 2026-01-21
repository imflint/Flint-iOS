//
//  SearchContentsImpl.swift
//  Data
//
//  Created by 소은 on 1/20/26.
//

import Combine
import Foundation

import Domain

import DTO
import Networking

final class DefaultSearchRepository: SearchRepository {
    
    private let searchService: SearchService
    
    public init(searchService: SearchService) {
        self.searchService = searchService
    }
    
    public func searchContents(_ keyword: String) -> AnyPublisher<SearchContentsEntity, NetworkError> {
        searchService.searchContents(keyword)
            .map(\.entity)
            .eraseToAnyPublisher()
    }
}
