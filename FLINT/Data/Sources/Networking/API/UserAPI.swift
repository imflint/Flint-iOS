//
//  File.swift
//  Data
//
//  Created by 김호성 on 2026.01.19.
//

import Foundation

import Domain

import Moya

enum UserAPI {
    case checkNickname(_ nickname: String)
}

extension UserAPI: TargetType {
    var baseURL: URL {
        guard let baseURL = URL(string: "https://flint.r-e.kr") else {
            Log.f("Invalid BaseURL")
            fatalError("Invalid BaseURL")
        }
        return baseURL
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

