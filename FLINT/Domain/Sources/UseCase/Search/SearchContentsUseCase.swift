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

public class DefaultSearchContentsUseCase: SearchContentsUseCase {
    
    let searchRepository: SearchRepository
    
    public init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
    }
    
    public func searchContents(_ keyword: String) -> AnyPublisher<[ContentEntity], Error> {
        return searchRepository.searchContents(keyword)
    }
}
