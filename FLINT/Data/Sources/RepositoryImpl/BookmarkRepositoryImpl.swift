//
//  BookmarkRepositoryImpl.swift
//  Data
//
//  Created by 소은 on 1/21/26.
//

import Combine
import Foundation

import Domain

import DTO
import Networking

public final class DefaultBookmarkRepository: BookmarkRepository {
    
    private let bookmarkService: BookmarkService
    
    public init(bookmarkService: BookmarkService) {
        self.bookmarkService = bookmarkService
    }
    
    public func fetchCollectionBookmarkUsers(collectionId: Int64) -> AnyPublisher<CollectionBookmarkUsersEntity, Error> {
        return bookmarkService.fetchCollectionBookmarkUsers(collectionId: collectionId)
            .tryMap { try $0.entity }
            .eraseToAnyPublisher()
    }
    
    public func toggleCollectionBookmark(collectionId: Int64) -> AnyPublisher<Bool, Error> {
        return bookmarkService.toggleCollectionBookmark(collectionId: collectionId)
    }
    
    public func toggleContentBookmark(contentId: Int64) -> AnyPublisher<Bool, Error> {
        return bookmarkService.toggleContentBookmark(contentId: contentId)
    }
}
