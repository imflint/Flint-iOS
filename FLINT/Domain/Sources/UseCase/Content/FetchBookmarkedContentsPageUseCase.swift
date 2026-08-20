//
//  FetchBookmarkedContentsPageUseCase.swift
//  Domain
//
//  Created by 진소은 on 8/20/26.
//

import Combine
import Foundation

import Repository

public protocol FetchBookmarkedContentsPageUseCase {
    func callAsFunction(cursor: String?, size: Int32?) -> AnyPublisher<BookmarkedContentPageEntity, Error>
}

public final class DefaultFetchBookmarkedContentsPageUseCase: FetchBookmarkedContentsPageUseCase {

    private let contentRepository: ContentRepository

    public init(contentRepository: ContentRepository) {
        self.contentRepository = contentRepository
    }

    public func callAsFunction(cursor: String?, size: Int32?) -> AnyPublisher<BookmarkedContentPageEntity, Error> {
        return contentRepository.fetchMyBookmarkedContentsPage(cursor: cursor, size: size)
    }
}
