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
}

extension ContentAPI: TargetType {
    
    public var path: String {
        switch self {
        case .fetchOTTPlatforms(let contentId):
            return "/api/v1/contents/ott/\(contentId)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .fetchOTTPlatforms:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .fetchOTTPlatforms:
            return .requestPlain
        }
    }
}

