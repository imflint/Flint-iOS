//
//  FetchBookmarkedUserUseCase.swift
//  Domain
//
//  Created by 진소은 on 1/23/26.
//

import Foundation

import Combine

import Entity
import Repository

public protocol FetchBookmarkedUserUseCase {
    func execute(collectionId: Int64)
    -> AnyPublisher<CollectionBookmarkUsersEntity, Error>
}

public final class DefaultFetchBookmarkedUserUseCase: FetchBookmarkedUserUseCase {
    
    private let bookmarkRepository: BookmarkRepository
    
    public init(bookmarkRepository: BookmarkRepository) {
        self.bookmarkRepository = bookmarkRepository
    }
    
    public func execute(collectionId: Int64)
    -> AnyPublisher<CollectionBookmarkUsersEntity, Error> {
        return bookmarkRepository.fetchCollectionBookmarkUsers(collectionId)
    }
}
