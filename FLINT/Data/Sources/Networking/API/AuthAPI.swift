//
//  File.swift
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
    case signup(_ signupInfoEntity: SignupRequestDTO)
    case socialVerify(_socialVerifyRequestDTO: SocialVerifyRequestDTO)
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
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .logout, .logoutAll, .refresh, .signup, .socialVerify:
            return .post
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .signup(let signupInfoEntity):
            return .requestJSONEncodable(signupInfoEntity)
        case .logout, .logoutAll, .refresh:
            return .requestPlain
        case .socialVerify(let socialVerifyRequestDTO):
            return .requestJSONEncodable(socialVerifyRequestDTO)
        }
    }
}
