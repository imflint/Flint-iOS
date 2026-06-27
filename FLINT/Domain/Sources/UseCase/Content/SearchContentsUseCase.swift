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
    func callAsFunction(keyword: String?, genre: Set<Genre>, mediaType: MediaType?, cursor: String?) -> AnyPublisher<[ContentEntity], Error>
}

public class DefaultSearchContentsUseCase: SearchContentsUseCase {
    
    let contentRepository: ContentRepository
    
    public init(contentRepository: ContentRepository) {
        self.contentRepository = contentRepository
    }
    
    public func callAsFunction(keyword: String?, genre: Set<Genre>, mediaType: MediaType?, cursor: String?) -> AnyPublisher<[ContentEntity], Error> {
        return contentRepository.searchContents(keyword: keyword, genre: genre, mediaType: mediaType, cursor: cursor, size: 20)
    }
}
