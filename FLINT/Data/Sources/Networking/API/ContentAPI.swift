//
//  ContentAPI.swift
//  Data
//
//  Created by 소은 on 1/21/26.
//


import Foundation

import Moya

import Domain

public enum ContentAPI {
    case fetchOTTPlatforms(_ contentId: Int64)
    case fetchBookmarkedContents
}

extension ContentAPI: TargetType {
    
    public var baseURL: URL {
        guard let baseURL = URL(string: "https://flint.r-e.kr") else {
            Log.f("Invalid BaseURL")
            fatalError("Invalid BaseURL")
        }
        return baseURL
    }
    
    public var path: String {
        switch self {
        case .fetchOTTPlatforms(let contentId):
            return "/api/v1/contents/ott/\(contentId)"
        case .fetchBookmarkedContents:
            return "/api/v1/contents/bookmarks"
           }
        }
    
    public var method: Moya.Method {
        switch self {
        case .fetchOTTPlatforms, .fetchBookmarkedContents:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .fetchOTTPlatforms, .fetchBookmarkedContents:
            return .requestPlain
        }
    }
}

