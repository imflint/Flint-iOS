//
//  AuthAPI.swift
//  Data
//
//  Created by 김호성 on 2026.01.21.
//

import Foundation

import Moya

import DTO

public enum AuthAPI {
    case logout(refreshToken: String)
    case logoutAll
    case refresh(refreshToken: String)
    case signup(userInfo: SignupRequestDTO)
    case socialVerify(socialAuthCredential: SocialVerifyRequestDTO)
    case withdraw(agreedTermsIds: [String])
}

extension AuthAPI: TargetType {
    public var path: String {
        switch self {
        case .signup:
            return "/api/v1/auth/signup"
        case .logout:
            return "/api/v1/auth/logout"
        case .refresh:
            return "api/v1/auth/refresh"
        case .logoutAll:
            #warning("TODO: - 나중에 구현할 것")
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
        case let .logout(refreshToken):
            return .requestJSONEncodable(LogoutRequestDTO(refreshToken: refreshToken))
        case let .refresh(refreshToken):
            return .requestJSONEncodable(RefreshRequestDTO(refreshToken: refreshToken))
        case .logoutAll:
            return .requestPlain
        case let .withdraw(agreedTermsIds):
            return .requestJSONEncodable(WithdrawRequestDTO(agreedTermsIds: agreedTermsIds))
        }
    }
}
