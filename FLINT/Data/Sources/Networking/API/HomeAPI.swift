//
//  HomeAPI.swift
//  Data
//
//  Created by 소은 on 1/20/26.
//

import Foundation

import Moya

public enum HomeAPI {
    case fetchRecommendedCollections
    case fetchPopularCollections
}

extension HomeAPI: TargetType {
    public var path: String {
        switch self {
        case .fetchRecommendedCollections:
            return "/api/v1/home/recommended-collections"
            
        case .fetchPopularCollections:
            return "/api/v1/home/popular-collections"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .fetchRecommendedCollections, .fetchPopularCollections:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .fetchRecommendedCollections, .fetchPopularCollections:
            return .requestPlain
        }
    }
}
