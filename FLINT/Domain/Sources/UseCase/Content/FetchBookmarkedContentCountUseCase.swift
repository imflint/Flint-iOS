//
//  FetchBookmarkedContentCountUseCase.swift
//  Domain
//
//  Created by 진소은 on 8/20/26.
//

import Combine
import Foundation

import Repository

public protocol FetchBookmarkedContentCountUseCase {
    func callAsFunction() -> AnyPublisher<Int, Error>
}

public final class DefaultFetchBookmarkedContentCountUseCase: FetchBookmarkedContentCountUseCase {

    private let contentRepository: ContentRepository

    public init(contentRepository: ContentRepository) {
        self.contentRepository = contentRepository
    }

    public func callAsFunction() -> AnyPublisher<Int, Error> {
        return contentRepository.fetchMyBookmarkedContentCount()
    }
}
