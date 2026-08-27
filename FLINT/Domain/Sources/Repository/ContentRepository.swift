//
//  ContentRepository.swift
//  Domain
//
//  Created by 소은 on 1/21/26.
//

import Combine
import Foundation

import Entity

public protocol ContentRepository {
    func searchContents(keyword: String?, genre: Set<Genre>, mediaType: MediaType?, cursor: String?, size: Int32) -> AnyPublisher<[ContentEntity], Error>
    func fetchMyBookmarkedContentsPage(cursor: String?, size: Int32?) -> AnyPublisher<BookmarkedContentPageEntity, Error>
    func fetchMyBookmarkedContentCount() -> AnyPublisher<Int, Error>
    func fetchOTTPlatformsForContent(contentId: Int64) -> AnyPublisher<[OTTPlatformEntity], Error>
}

public struct BookmarkedContentPageEntity: Equatable {
    public let items: [ContentInfoEntity]
    public let nextCursor: String?

    public init(items: [ContentInfoEntity], nextCursor: String?) {
        self.items = items
        self.nextCursor = nextCursor
    }
}
