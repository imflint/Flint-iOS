//
//  SearchContentsAPI.swift
//  Data
//
//  Created by 소은 on 1/20/26.
//

import Foundation

import Moya

import Domain

enum SearchAPI {
    case searchContents(_ keyword: String)
}

extension SearchAPI: TargetType {
    var baseURL: URL {
        guard let baseURL = URL(string: "https://flint.r-e.kr") else {
            Log.f("Invalid BaseURL")
            fatalError("Invalid BaseURL")
        }
        return baseURL
    }
    
    var path: String {
        switch self {
        case .searchContents:
            return "/api/v1/search/contents"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .searchContents:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .searchContents(let keyword):
            return .requestParameters(
                parameters: ["keyword": keyword],
                encoding: URLEncoding.queryString
            )
        }
    }
}
