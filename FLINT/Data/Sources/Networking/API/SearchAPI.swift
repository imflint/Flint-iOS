//
//  SearchContentsAPI.swift
//  Data
//
//  Created by 소은 on 1/20/26.
//

import Foundation

import Moya

import Domain

public enum SearchAPI {
    case searchContents(_ keyword: String?)
}

extension SearchAPI: TargetType {
    
    public var path: String {
        switch self {
        case .searchContents:
            return "/api/v1/search/contents"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .searchContents:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .searchContents(let keyword):
            var parameters: [String: Any] = [:]
            if let keyword {
                parameters["keyword"] = keyword
            }
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.queryString
            )
        }
    }
}
