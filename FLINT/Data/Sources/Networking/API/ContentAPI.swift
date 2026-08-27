//
//  ContentAPI.swift
//  Data
//
//  Created by 소은 on 1/21/26.
//

import Foundation

import Moya

public enum ContentAPI {
    case fetchMyBookmarkedContents(cursor: String?, size: Int32?)
    case fetchMyBookmarkedContentCount
    case fetchOTTPlatformsForContent(contentId: Int64)
    case searchContents(keyword: String?, genre: [String], mediaType: String?, cursor: String?, size: Int32)
}

extension ContentAPI: TargetType {
    public var path: String {
        switch self {
        case .fetchMyBookmarkedContents:
            return "/api/v1/contents/bookmarks"
        case .fetchMyBookmarkedContentCount:
            return "/api/v1/contents/bookmarks/count"
        case let .fetchOTTPlatformsForContent(contentId):
            return "/api/v1/contents/ott/\(contentId)"
        case .searchContents:
            return "/api/v1/contents/search"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .fetchMyBookmarkedContents, .fetchMyBookmarkedContentCount, .fetchOTTPlatformsForContent, .searchContents:
            return .get
        }
    }

    public var task: Moya.Task {
        switch self {
        case .fetchMyBookmarkedContentCount, .fetchOTTPlatformsForContent:
            return .requestPlain
        case let .fetchMyBookmarkedContents(cursor, size):
            var parameters: [String: Any] = [:]
            if let cursor { parameters["cursor"] = cursor }
            if let size { parameters["size"] = size }
            if parameters.isEmpty { return .requestPlain }
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.queryString
            )
        case let .searchContents(keyword, genre, mediaType, cursor, size):
            var parameters: [String: Any] = [
                "genre": genre,
                "size": size
            ]
            if let keyword {
                parameters["keyword"] = keyword
            }
            if let mediaType {
                parameters["mediaType"] = mediaType
            }
            if let cursor {
                parameters["cursor"] = cursor
            }

            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.queryString
            )
        }
    }
}
