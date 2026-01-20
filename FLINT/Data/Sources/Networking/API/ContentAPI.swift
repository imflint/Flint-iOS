//
//  ContentAPI.swift
//  Data
//
//  Created by 소은 on 1/21/26.
//

import Foundation

import Moya

import Domain

enum ContentAPI {
    case fetchOTTPlatforms(_ contentId: Int64)
}

extension ContentAPI: TargetType {
    
    var baseURL: URL {
        guard let baseURL = URL(string: "https://flint.r-e.kr") else {
            Log.f("Invalid BaseURL")
            fatalError("Invalid BaseURL")
        }
        return baseURL
    }
    
    var path: String {
        switch self {
        case .fetchOTTPlatforms(let contentId):
            return "/api/v1/contents/ott/\(contentId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchOTTPlatforms:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchOTTPlatforms:
            return .requestPlain
        }
    }
}
