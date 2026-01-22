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
    func toggleCollectionBookmark(_ collectionId: Int64) -> AnyPublisher<Bool, Error>
    func toggleContentBookmark(_ contentId: Int64) -> AnyPublisher<Bool, Error>
}

public final class DefaultBookmarkService: BookmarkService {
    
    private let provider: MoyaProvider<BookmarkAPI>
    
    public init(provider: MoyaProvider<BookmarkAPI>) {
        self.provider = provider
    }
    
    public func toggleCollectionBookmark(_ collectionId: Int64) -> AnyPublisher<Bool, Error> {
        return provider.requestPublisher(.toggleCollectionBookmark(collectionId))
            .extractData(Bool.self)
    }
    
    public func toggleContentBookmark(_ contentId: Int64) -> AnyPublisher<Bool, Error> {
        return provider.requestPublisher(.toggleContentBookmark(contentId))
            .extractData(Bool.self)
    }
}
