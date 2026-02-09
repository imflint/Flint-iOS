//
//  BookmarkRepository.swift
//  Domain
//
//  Created by 소은 on 1/21/26.
//

import Combine
import Foundation

import Entity

public protocol BookmarkRepository {
    func fetchCollectionBookmarkUsers(collectionId: Int64) -> AnyPublisher<CollectionBookmarkUsersEntity, Error>
    func toggleCollectionBookmark(collectionId: Int64) -> AnyPublisher<Bool, Error>
    func toggleContentBookmark(contentId: Int64) -> AnyPublisher<Bool, Error>
}
