//
//  BookmarkAPI.swift
//  Data
//
//  Created by 소은 on 1/21/26.
//

import Foundation

import Domain

import Moya

public enum BookmarkAPI {
    case toggleCollectionBookmark(_ collectionId: Int64)
    case toggleContentBookmark(_ contentId: Int64)
    case fetchCollectionBookmarkUsers(collectionId: Int64)
}

extension BookmarkAPI: TargetType {
    
    public var path: String {
        switch self {
        case .toggleCollectionBookmark(let collectionId):
            return "/api/v1/bookmarks/collections/\(collectionId)"
        case .toggleContentBookmark(let contentId):
            return "/api/v1/bookmarks/contents/\(contentId)"
        case let .fetchCollectionBookmarkUsers(collectionId):
            return "/api/v1/bookmarks/\(collectionId)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .toggleCollectionBookmark:
            return .post
        case .toggleContentBookmark:
            return .post
        case .fetchCollectionBookmarkUsers:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .toggleCollectionBookmark:
            return .requestPlain
        case .toggleContentBookmark:
            return .requestPlain
        case .fetchCollectionBookmarkUsers:
            return .requestPlain
        }
    }
}
