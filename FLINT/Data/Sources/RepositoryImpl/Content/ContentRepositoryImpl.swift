//
//  ContentRepository.swift
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
    
    public func fetchOTTPlatforms(_ contentId: Int64) -> AnyPublisher<[OTTPlatformEntity], Error> {
        return contentService.fetchOTTPlatforms(contentId)
            .tryMap({ try $0.entity })
            .eraseToAnyPublisher()
    }
    
    public func fetchBookmarkedContents() -> AnyPublisher<BookmarkContentsListEntity, NetworkError> {
        return contentService.fetchBookmarkedContents()
            .map(\.entity)
           // .tryMap ({try $0.entity})
            .eraseToAnyPublisher()
    }
}

