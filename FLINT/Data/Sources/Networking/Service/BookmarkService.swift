//
//  BookmarkService.swift
//  Data
//
//  Created by 소은 on 1/21/26.
//

import Combine
import Foundation

import CombineMoya
import Moya

import Domain

import DTO

public protocol BookmarkService {
    func fetchCollectionBookmarkUsers(collectionId: Int64)
    -> AnyPublisher<CollectionBookmarkUsersDTO, Error>
    func toggleCollectionBookmark(collectionId: Int64) -> AnyPublisher<Bool, Error>
    func toggleContentBookmark(contentId: Int64) -> AnyPublisher<Bool, Error>
}

public final class DefaultBookmarkService: BookmarkService {
    
    private let bookmarkAPIProvider: MoyaProvider<BookmarkAPI>
    
    public init(bookmarkAPIProvider: MoyaProvider<BookmarkAPI>) {
        self.bookmarkAPIProvider = bookmarkAPIProvider
    }
    
    public func fetchCollectionBookmarkUsers(collectionId: Int64)
    -> AnyPublisher<CollectionBookmarkUsersDTO, Error> {
        return bookmarkAPIProvider.requestPublisher(.fetchCollectionBookmarkUsers(collectionId: collectionId))
            .mapBaseResponseData(CollectionBookmarkUsersDTO.self)
    }
    
    public func toggleCollectionBookmark(collectionId: Int64) -> AnyPublisher<Bool, Error> {
        bookmarkAPIProvider.requestPublisher(.toggleCollectionBookmark(collectionId: collectionId))
            .mapBaseResponseData(Bool.self)
    }
    
    public func toggleContentBookmark(contentId: Int64) -> AnyPublisher<Bool, Error> {
        bookmarkAPIProvider.requestPublisher(.toggleContentBookmark(contentId: contentId))
            .mapBaseResponseData(Bool.self)
    }
}
