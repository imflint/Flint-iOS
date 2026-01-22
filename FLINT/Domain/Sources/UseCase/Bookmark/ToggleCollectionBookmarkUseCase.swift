//
//  ToggleCollectionBookmarkUseCase.swift
//  Domain
//
//  Created by 소은 on 1/21/26.
//

import Combine
import Foundation

import Entity
import Repository

public protocol ToggleCollectionBookmarkUseCase {
    func toggleCollectionBookmark(_ collectionId: Int64) -> AnyPublisher<Bool, Error>
}

public class DefaultToggleCollectionBookmarkUseCase: ToggleCollectionBookmarkUseCase {

    private let bookmarkRepository: BookmarkRepository

    public init(bookmarkRepository: BookmarkRepository) {
        self.bookmarkRepository = bookmarkRepository
    }

    public func toggleCollectionBookmark(_ collectionId: Int64) -> AnyPublisher<Bool, Error> {
        return bookmarkRepository.toggleCollectionBookmark(collectionId)
    }
}

