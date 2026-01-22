//
//  SearchContentsUseCase.swift
//  Domain
//
//  Created by 소은 on 1/20/26.
//

import Combine
import Foundation

import Entity
import Repository

public protocol SearchContentsUseCase: AnyObject {
    func searchContents(keyword: String) -> AnyPublisher<SearchContentsEntity, Error>
}

public class DefaultSearchContentsUseCase: SearchContentsUseCase {
    
    private let repository: SearchRepository
    
    public init(repository: SearchRepository) {
        self.repository = repository
    }
    
    public func searchContents(keyword: String) -> AnyPublisher<SearchContentsEntity, Error> {
        repository.searchContents(keyword: keyword)
    }
    
}


