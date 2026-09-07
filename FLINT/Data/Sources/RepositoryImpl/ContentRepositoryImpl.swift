//
//  ContentRepositoryImpl.swift
//  Data
//
//  Created by 소은 on 1/21/26.
//

import Combine
import Foundation

import Domain

import DTO
import Networking

public final class DefaultContentRepository: ContentRepository {
    
    private let contentService: ContentService
    
    public init(contentService: ContentService) {
        self.contentService = contentService
    }
    
    public func searchContents(keyword: String?, genre: Set<Genre>, mediaType: MediaType?, cursor: String?, size: Int32) -> AnyPublisher<SearchContentEntity, Error> {
        return contentService.searchContents(keyword: keyword, genre: genre.map { $0.rawValue }, mediaType: mediaType?.rawValue, cursor: cursor, size: size)
            .tryMap({ try $0.entity })
            .eraseToAnyPublisher()
    }
    
    public func fetchMyBookmarkedContentsPage(cursor: String?, size: Int32?) -> AnyPublisher<BookmarkedContentPageEntity, Error> {
        return contentService.fetchMyBookmarkedContents(cursor: cursor, size: size)
            .tryMap { dto in
                BookmarkedContentPageEntity(
                    items: try dto.entities,
                    nextCursor: dto.meta?.nextCursor
                )
            }
            .eraseToAnyPublisher()
    }

    public func fetchMyBookmarkedContentCount() -> AnyPublisher<Int, Error> {
        return contentService.fetchMyBookmarkedContentCount()
            .map { $0.totalCount ?? 0 }
            .eraseToAnyPublisher()
    }

    public func fetchOTTPlatformsForContent(contentId: Int64) -> AnyPublisher<[OTTPlatformEntity], Error> {
        return contentService.fetchOTTPlatformsForContent(contentId: contentId)
            .tryMap({ try $0.entity })
            .eraseToAnyPublisher()
    }
}
