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
    
    public func fetchMyBookmarkedContents() -> AnyPublisher<[ContentInfoEntity], Error> {
        return contentService.fetchMyBookmarkedContents()
            .tryMap { try $0.entities }
            .eraseToAnyPublisher()
    }
    
    public func fetchOTTPlatformsForContent(contentId: Int64) -> AnyPublisher<[OTTPlatformEntity], Error> {
        return contentService.fetchOTTPlatformsForContent(contentId: contentId)
            .tryMap({ try $0.entity })
            .eraseToAnyPublisher()
    }
}
