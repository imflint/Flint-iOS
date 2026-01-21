//
//  File.swift
//  Data
//
//  Created by 김호성 on 2026.01.19.
//

import Foundation

import Moya

import Domain

enum UserAPI {
    case checkNickname(_ nickname: String)
}

extension UserAPI: TargetType {
    var baseURL: URL {
        return NetworkConfig.baseURL
    }
    
    var path: String {
        switch self {
        case .checkNickname:
            return "/api/v1/users/nickname/check"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .checkNickname:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .checkNickname(let nickname):
            return .requestParameters(parameters: [
                "nickname": nickname
            ], encoding: URLEncoding.queryString)
        }
    }
}
