//
//  HomeAPI.swift
//  Data
//
//  Created by 소은 on 1/20/26.
//

import Foundation

import Domain

import Moya

enum HomeAPI {
    case fetchRecommendedCollections
}

extension HomeAPI: TargetType {
    
    var baseURL: URL {
        guard let baseURL = URL(string: "https://flint.r-e.kr") else {
            Log.f("Invalid BaseURL")
            fatalError("Invalid BaseURL")
        }
        return baseURL
    }
    
    var path: String {
        switch self {
        case .fetchRecommendedCollections:
            return "/api/v1/home/recommended-collections"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchRecommendedCollections:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchRecommendedCollections:
            return .requestPlain
        }
    }
}
