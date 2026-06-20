//
//  CollectionAPI.swift
//  Data
//
//  Created by 소은 on 1/20/26.
//

import Foundation

import Moya

import Domain
import DTO

public enum CollectionAPI {
    case fetchCollections(cursor: Int64?, size: Int32)
    case createCollection(collectionInfo: CreateCollectionEntity)
    case fetchCollectionDetail(collectionId: Int64)
    case fetchRecentViewedCollections
    case reportCollection(collectionId: Int64, reasons: [String], otherDetail: String?)
}

extension CollectionAPI: TargetType {
    public var path: String {
        switch self {
        case .fetchCollections, .createCollection:
            return "/api/v1/collections"
        case let .fetchCollectionDetail(collectionId):
            return "/api/v1/collections/\(collectionId)"
        case .fetchRecentViewedCollections:
            return "/api/v1/collections/recent"
        case let .reportCollection(collectionId, _, _):
            return "/api/v1/collections/\(collectionId)/reports"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .fetchCollections, .fetchCollectionDetail, .fetchRecentViewedCollections:
            return .get
        case .createCollection, .reportCollection:
            return .post
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case let .fetchCollections(cursor, size):
            var parameters: [String: Any] = ["size": size]
            if let cursor {
                parameters["cursor"] = cursor
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case let .createCollection(collectionInfo):
            return .requestJSONEncodable(collectionInfo)
        case .fetchCollectionDetail, .fetchRecentViewedCollections:
            return .requestPlain
        case let .reportCollection(_, reasons, otherDetail):
            return .requestJSONEncodable(ReportRequestDTO(reasons: reasons, otherDetail: otherDetail))
        }
    }
}
