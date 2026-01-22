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
}

extension CollectionAPI: TargetType {
    
    public var path: String {
        switch self {
        case .createCollection:
            return "/api/v1/collections"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .createCollection:
            return .post
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .createCollection(let request):
            return .requestJSONEncodable(request)
            
        }
    }
}

