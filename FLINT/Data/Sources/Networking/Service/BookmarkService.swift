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
    func toggleCollectionBookmark(_ collectionId: Int64) -> AnyPublisher<Bool, NetworkError>
}

public final class DefaultBookmarkService: BookmarkService {

    private let provider = MoyaProvider<BookmarkAPI>()

    public init() { }

    public func toggleCollectionBookmark(_ collectionId: Int64) -> AnyPublisher<Bool, NetworkError> {
        return provider.requestPublisher(.toggleCollectionBookmark(collectionId))
            .extractData(Bool.self)
    }
}
