//
//  DefaultBookmarkRepository.swift
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

    public func toggleCollectionBookmark(_ collectionId: Int64) -> AnyPublisher<Bool, Error> {
        return bookmarkService.toggleCollectionBookmark(collectionId)
    }
    
    public func toggleContentBookmark(_ contentId: Int64) -> AnyPublisher<Bool, Error> {
           return bookmarkService.toggleContentBookmark(contentId)
       }
}
