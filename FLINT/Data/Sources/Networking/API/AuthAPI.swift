//
//  AuthAPI.swift
//  Data
//
//  Created by 김호성 on 2026.01.21.
//

import Foundation

import Moya

import Domain

import DTO

public enum AuthAPI {
    case logout
    case logoutAll
    case refresh
    case signup(userInfo: SignupRequestDTO)
    case socialVerify(socialAuthCredential: SocialVerifyRequestDTO)
    case withdraw
}

extension AuthAPI: TargetType {
    public var path: String {
        switch self {
        case .signup:
            return "/api/v1/auth/signup"
        case .logout, .logoutAll, .refresh:
            return "TODO"
        case .socialVerify:
            return "/api/v1/auth/social/verify"
        case .withdraw:
            return "/api/v1/auth/withdraw"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .logout, .logoutAll, .refresh, .signup, .socialVerify:
            return .post
        case .withdraw:
            return .delete
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case let .signup(userInfo):
            return .requestJSONEncodable(userInfo)
        case let .socialVerify(socialAuthCredential):
            return .requestJSONEncodable(socialAuthCredential)
        case .logout, .logoutAll, .refresh, .withdraw:
            return .requestPlain
        }
    }
}
