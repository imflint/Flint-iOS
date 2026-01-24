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
    case fetchCollectionDetail(collectionId: Int64)
    case fetchWatchingCollections
}

extension CollectionAPI: TargetType {
    
    public var path: String {
        switch self {
        case .fetchCollections:
            return "/api/v1/collections"
        case .createCollection:
            return "/api/v1/collections"
        case let .fetchCollectionDetail(collectionId):
            return "/api/v1/collections/\(collectionId)"
        case let .fetchWatchingCollections:
            return "/api/v1/collections/recent"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .fetchCollections:
            return .get
        case .createCollection:
            return .post
        case .fetchCollectionDetail:
            return .get
        case .fetchWatchingCollections:
            return .get
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
        case .fetchCollectionDetail:
            return .requestPlain
        case .fetchWatchingCollections:
            return .requestPlain
        }
    }
}

