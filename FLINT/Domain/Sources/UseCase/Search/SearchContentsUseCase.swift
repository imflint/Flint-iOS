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
    func searchContents(_ keyword: String) -> AnyPublisher<[ContentEntity], Error>
}

public class DefaultSearchContentsUSeCase: SearchContentsUseCase {
    
    let searchContentsrepository: SearchRepository
    
    public init(searchContentsrepository: SearchRepository) {
        self.searchContentsrepository = searchContentsrepository
    }
    
    public func searchContents(_ keyword: String) -> AnyPublisher<[ContentEntity], Error> {
        return searchContentsrepository.searchContents(keyword)
    }
}


