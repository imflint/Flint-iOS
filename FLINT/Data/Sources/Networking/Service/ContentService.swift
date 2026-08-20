//
//  ContentService.swift
//  Data
//
//  Created by 소은 on 1/21/26.
//

import Combine
import Foundation

import CombineMoya
import Moya

import DTO

public protocol ContentService {
    func searchContents(keyword: String?, genre: [String], mediaType: String?, cursor: String?, size: Int32) -> AnyPublisher<SearchContentsDTO, Error>
    func fetchMyBookmarkedContents(cursor: String?, size: Int32?) -> AnyPublisher<ContentsDTO, Error>
    func fetchMyBookmarkedContentCount() -> AnyPublisher<BookmarkedContentCountDTO, Error>
    func fetchOTTPlatformsForContent(contentId: Int64) -> AnyPublisher<OTTPlatformsDTO, Error>
}

public final class DefaultContentService: ContentService {

    private let contentAPIProvider: MoyaProvider<ContentAPI>

    public init(contentAPIProvider: MoyaProvider<ContentAPI>) {
        self.contentAPIProvider = contentAPIProvider
    }
    
    public func searchContents(keyword: String?, genre: [String], mediaType: String?, cursor: String?, size: Int32) -> AnyPublisher<SearchContentsDTO, Error> {
        return contentAPIProvider.requestPublisher(
            .searchContents(
                keyword: keyword,
                genre: genre,
                mediaType: mediaType,
                cursor: cursor,
                size: size
            )
        )
        .mapBaseResponseData(SearchContentsDTO.self)
    }
    
    public func fetchMyBookmarkedContents(cursor: String?, size: Int32?) -> AnyPublisher<ContentsDTO, Error> {
        return contentAPIProvider.requestPublisher(.fetchMyBookmarkedContents(cursor: cursor, size: size))
            .mapBaseResponseData(ContentsDTO.self)
    }

    public func fetchMyBookmarkedContentCount() -> AnyPublisher<BookmarkedContentCountDTO, Error> {
        return contentAPIProvider.requestPublisher(.fetchMyBookmarkedContentCount)
            .mapBaseResponseData(BookmarkedContentCountDTO.self)
    }

    public func fetchOTTPlatformsForContent(contentId: Int64) -> AnyPublisher<OTTPlatformsDTO, Error> {
        return contentAPIProvider.requestPublisher(.fetchOTTPlatformsForContent(contentId: contentId))
            .mapBaseResponseData(OTTPlatformsDTO.self)
    }
}

