//
//  ContentAPI.swift
//  Data
//
//  Created by 소은 on 1/21/26.
//

import Foundation

import Moya

public enum ContentAPI {
    case fetchMyBookmarkedContents
    case fetchOTTPlatformsForContent(contentId: Int64)
}

extension ContentAPI: TargetType {
    public var path: String {
        switch self {
        case .fetchMyBookmarkedContents:
            return "/api/v1/contents/bookmarks"
        case let .fetchOTTPlatformsForContent(contentId):
            return "/api/v1/contents/ott/\(contentId)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .fetchMyBookmarkedContents, .fetchOTTPlatformsForContent:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .fetchMyBookmarkedContents, .fetchOTTPlatformsForContent:
            return .requestPlain
        }
    }
}
