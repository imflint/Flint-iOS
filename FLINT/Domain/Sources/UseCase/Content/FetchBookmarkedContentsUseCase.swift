//
//  FetchBookmarkedContentsUseCase.swift
//  Domain
//
//  Created by 소은 on 1/21/26.
//

import Combine
import Foundation

import Entity
import Repository

public protocol FetchBookmarkedContentsUseCase {
    func fetchBookmarkedContents() -> AnyPublisher<BookmarkContentsListEntity, NetworkError>
}

public class DefaultFetchBookmarkedContentsUseCase: FetchBookmarkedContentsUseCase {

    let contentRepository: ContentRepository

    public init(contentRepository: ContentRepository) {
        self.contentRepository = contentRepository
    }

    public func fetchBookmarkedContents() -> AnyPublisher<BookmarkContentsListEntity, NetworkError> {
        return contentRepository.fetchBookmarkedContents()
    }
}
