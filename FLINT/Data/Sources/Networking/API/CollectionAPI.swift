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
    case fetchCollections(cursor: UInt?, size: Int)
    case createCollection(_ request: CreateCollectionEntity)
}

extension CollectionAPI: TargetType {
    
    public var path: String {
        switch self {
        case .fetchCollections:
            return "/api/v1/collections"
        case .createCollection:
            return "/api/v1/collections"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .fetchCollections:
            return .get
        case .createCollection:
            return .post
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .fetchCollections(let cursor, let size):
            var parameters: [String: Any] = [
                "size": size,
            ]
            if let cursor {
                parameters["cursor"] = cursor
            }
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.queryString
            )
        case .createCollection(let request):
            return .requestJSONEncodable(request)
        }
    }
}

