//
//  File.swift
//  Data
//
//  Created by 김호성 on 2026.01.19.
//

import Foundation

import Moya

import Domain

public enum UserAPI {
    case checkNickname(_ nickname: String)
    case fetchUserProfile(userId: Int64)
    case fetchMyProfile
}

extension UserAPI: TargetType {
    public var baseURL: URL {
        return NetworkConfig.baseURL
    }
    
    public var path: String {
        switch self {
        case .checkNickname:
            return "/api/v1/users/nickname/check"
        case let .fetchUserProfile(userId):
            return "/api/v1/users/\(userId)"
        case .fetchMyProfile:
            return "/api/v1/users/me"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .checkNickname:
            return .get
        case .fetchUserProfile:
            return .get
        case .fetchMyProfile:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .checkNickname(let nickname):
            return .requestParameters(
                parameters: ["nickname": nickname],
                encoding: URLEncoding.queryString)
        case .fetchUserProfile:
            return .requestPlain
        case .fetchMyProfile:
            return .requestPlain
        }
    }
}
