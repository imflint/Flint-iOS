//
//  CollectionAPI.swift
//  Data
//
//  Created by 소은 on 1/20/26.
//

import Foundation

import Domain

import Moya

public enum CollectionAPI {
    case createCollection(_ request: CreateCollectionEntity)
    case fetchRecentCollections
}

extension CollectionAPI: TargetType {
    public var baseURL: URL {
        guard let baseURL = URL(string: "https://flint.r-e.kr") else {
            Log.f("Invalid BaseURL")
            fatalError("Invalid BaseURL")
        }
        return baseURL
    }
    
    public var path: String {
        switch self {
        case .createCollection:
            return "/api/v1/collections"
        case .fetchRecentCollections:
            return "/api/v1/collections/recent"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .createCollection:
            return .post
        case .fetchRecentCollections:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .createCollection(let request):
            return .requestJSONEncodable(request)
        case .fetchRecentCollections:
            return .requestPlain
            
        }
    }
}

