//
//  FetchBookmarkedUserUseCase.swift
//  Domain
//
//  Created by 진소은 on 1/23/26.
//

import Combine
import Foundation

import Entity
import Repository

public protocol FetchCollectionBookmarkUsersUseCase {
    func fetchCollectionBookmarkUsers(collectionId: Int64) -> AnyPublisher<CollectionBookmarkUsersEntity, Error>
}

public final class DefaultFetchCollectionBookmarkUsersUseCase: FetchCollectionBookmarkUsersUseCase {
    
    private let bookmarkRepository: BookmarkRepository
    
    public init(bookmarkRepository: BookmarkRepository) {
        self.bookmarkRepository = bookmarkRepository
    }
    
    public func fetchCollectionBookmarkUsers(collectionId: Int64) -> AnyPublisher<CollectionBookmarkUsersEntity, Error> {
        return bookmarkRepository.fetchCollectionBookmarkUsers(collectionId: collectionId)
    }
}
