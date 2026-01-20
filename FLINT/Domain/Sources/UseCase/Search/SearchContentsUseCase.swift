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
    func searchContents(_ query: String) -> AnyPublisher<SearchContentsEntity, NetworkError>
}

public class DefaultSearchContentsUSeCase: SearchContentsUseCase {
    
    let searchContentsrepository: SearchRepository
    
    public init(searchContentsrepository: SearchRepository) {
        self.searchContentsrepository = searchContentsrepository
    }
    
    public func searchContents(_ query: String) -> AnyPublisher<SearchContentsEntity, NetworkError> {
        return searchContentsrepository.searchContents(query)
    }
    
}


