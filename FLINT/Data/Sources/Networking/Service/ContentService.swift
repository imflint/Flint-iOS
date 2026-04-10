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
    func fetchMyBookmarkedContents() -> AnyPublisher<ContentsDTO, Error>
    func fetchOTTPlatformsForContent(contentId: Int64) -> AnyPublisher<OTTPlatformsDTO, Error>
}

public final class DefaultContentService: ContentService {

    private let contentAPIProvider: MoyaProvider<ContentAPI>

    public init(contentAPIProvider: MoyaProvider<ContentAPI>) {
        self.contentAPIProvider = contentAPIProvider
    }
    
    public func fetchMyBookmarkedContents() -> AnyPublisher<ContentsDTO, Error> {
        return contentAPIProvider.requestPublisher(.fetchMyBookmarkedContents)
            .mapBaseResponseData(ContentsDTO.self)
    }
    
    public func fetchOTTPlatformsForContent(contentId: Int64) -> AnyPublisher<OTTPlatformsDTO, Error> {
        return contentAPIProvider.requestPublisher(.fetchOTTPlatformsForContent(contentId: contentId))
            .mapBaseResponseData(OTTPlatformsDTO.self)
    }
}

