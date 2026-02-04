//
//  BookmarkAPI.swift
//  Data
//
//  Created by 소은 on 1/21/26.
//

import Foundation

import Moya

import Domain

public enum BookmarkAPI {
    case fetchCollectionBookmarkUsers(collectionId: Int64)
    case toggleCollectionBookmark(collectionId: Int64)
    case toggleContentBookmark(contentId: Int64)
}

extension BookmarkAPI: TargetType {
    public var path: String {
        switch self {
        case let .fetchCollectionBookmarkUsers(collectionId):
            return "/api/v1/bookmarks/\(collectionId)"
        case let .toggleCollectionBookmark(collectionId):
            return "/api/v1/bookmarks/collections/\(collectionId)"
        case let .toggleContentBookmark(contentId):
            return "/api/v1/bookmarks/contents/\(contentId)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .fetchCollectionBookmarkUsers:
            return .get
        case .toggleCollectionBookmark, .toggleContentBookmark:
            return .post
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .fetchCollectionBookmarkUsers, .toggleCollectionBookmark, .toggleContentBookmark:
            return .requestPlain
        }
    }
}
