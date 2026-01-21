//
//  File.swift
//  Data
//
//  Created by 김호성 on 2026.01.21.
//

import Foundation

import Moya

import Domain

enum AuthAPI {
    case logout
    case logoutAll
    case refresh
    case signup(_ signupInfoEntity: SignupInfoEntity)
    case socialVerify
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return NetworkConfig.baseURL
    }
    
    var path: String {
        switch self {
        case .signup:
            return "/api/v1/auth/signup"
        case .logout, .logoutAll, .refresh, .socialVerify:
            return "TODO"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .logout, .logoutAll, .refresh, .signup, .socialVerify:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .signup(let signupInfoEntity):
            return .requestJSONEncodable(signupInfoEntity)
        case .logout, .logoutAll, .refresh, .socialVerify:
            return .requestPlain
        }
    }
}
