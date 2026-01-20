//
//  CollectionAPI.swift
//  Data
//
//  Created by 소은 on 1/20/26.
//

import Foundation

import Domain

import Moya

enum CollectionAPI {
    case createCollection(_ request: CreateCollectionEntity)
}

extension CollectionAPI: TargetType {
    var baseURL: URL {
        guard let baseURL = URL(string: "https://flint.r-e.kr") else {
            Log.f("Invalid BaseURL")
            fatalError("Invalid BaseURL")
        }
        return baseURL
    }
    
    var path: String {
        switch self {
        case .createCollection:
            return "/api/v1/collections"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createCollection:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .createCollection(let request):
            return .requestJSONEncodable(request)
            
        }
    }
}

