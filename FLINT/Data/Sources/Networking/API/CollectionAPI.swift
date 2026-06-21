//
//  CollectionAPI.swift
//  Data
//
//  Created by 소은 on 1/20/26.
//

import Foundation

import Moya

import Domain

public enum CollectionAPI {
    case fetchCollections(cursor: Int64?, size: Int32)
    case createCollection(collectionInfo: CreateCollectionEntity)
    case updateCollection(collectionId: Int64, collectionInfo: CreateCollectionEntity)
    case deleteCollection(collectionId: Int64)
    case fetchCollectionDetail(collectionId: Int64)
    case fetchRecentViewedCollections
}

extension CollectionAPI: TargetType {
    public var path: String {
        switch self {
        case .fetchCollections, .createCollection:
            return "/api/v1/collections"
        case let .fetchCollectionDetail(collectionId):
            return "/api/v1/collections/\(collectionId)"
        case let .updateCollection(collectionId, _):
            return "/api/v1/collections/\(collectionId)"
        case let .deleteCollection(collectionId):
            return "/api/v1/collections/\(collectionId)"
        case .fetchRecentViewedCollections:
            return "/api/v1/collections/recent"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .fetchCollections, .fetchCollectionDetail, .fetchRecentViewedCollections:
            return .get
        case .createCollection:
            return .post
        case .updateCollection:
            return .put
        case .deleteCollection:
            return .delete
        }
    }

    public var task: Moya.Task {
        switch self {
        case let .fetchCollections(cursor, size):
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
        case let .createCollection(collectionInfo):
            return .requestJSONEncodable(collectionInfo)
        case let .updateCollection(_, collectionInfo):
            return .requestJSONEncodable(collectionInfo)
        case .deleteCollection, .fetchCollectionDetail, .fetchRecentViewedCollections:
            return .requestPlain
        }
    }
}
