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
}

extension UserAPI: TargetType {
    public var path: String {
        switch self {
        case .checkNickname:
            return "/api/v1/users/nickname/check"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .checkNickname:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .checkNickname(let nickname):
            return .requestParameters(parameters: [
                "nickname": nickname
            ], encoding: URLEncoding.queryString)
        }
    }
}
