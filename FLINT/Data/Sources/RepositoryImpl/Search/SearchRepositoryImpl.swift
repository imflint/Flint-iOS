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

public final class DefaultSearchRepository: SearchRepository {
    
    private let searchService: SearchService
    
    public init(searchService: SearchService) {
        self.searchService = searchService
    }
    
    public func searchContents(keyword: String) -> AnyPublisher<SearchContentsEntity, Error> {
        searchService.searchContents(keyword: keyword)
            .tryMap({ try $0.entity })
            .eraseToAnyPublisher()
    }
}
