//
//  ToggleContentBookmarkUseCase.swift
//  Domain
//
//  Created by 소은 on 1/21/26.
//

import Combine
import Foundation

import Entity
import Repository

public protocol ToggleContentBookmarkUseCase {
    func callAsFunction(contentId: Int64) -> AnyPublisher<Bool, Error>
}

public class DefaultToggleContentBookmarkUseCase: ToggleContentBookmarkUseCase {

    private let bookmarkRepository: BookmarkRepository

    public init(bookmarkRepository: BookmarkRepository) {
        self.bookmarkRepository = bookmarkRepository
    }

    public func callAsFunction(contentId: Int64) -> AnyPublisher<Bool, Error> {
        return bookmarkRepository.toggleContentBookmark(contentId: contentId)
    }
}
