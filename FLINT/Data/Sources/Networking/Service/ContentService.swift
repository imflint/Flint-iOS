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

import Domain

import DTO

public protocol ContentService {
    func fetchOTTPlatforms(_ contentId: Int64) -> AnyPublisher<[FetchOTTPlatformsDTO], NetworkError>
    func fetchBookmarkedContents() -> AnyPublisher<BookmarkContentsListDTO, NetworkError>
}

public final class DefaultContentService: ContentService {
    
    private let provider = MoyaProvider<ContentAPI>()
    
    public init() { }
    
    public func fetchOTTPlatforms(_ contentId: Int64) -> AnyPublisher<[FetchOTTPlatformsDTO], NetworkError> {
        return provider.requestPublisher(.fetchOTTPlatforms(contentId))
            .extractData([FetchOTTPlatformsDTO].self)
    }
    
    public func fetchBookmarkedContents() -> AnyPublisher<BookmarkContentsListDTO, NetworkError> {
        return provider.requestPublisher(.fetchBookmarkedContents)
            .extractData(BookmarkContentsListDTO.self)
    }
}

