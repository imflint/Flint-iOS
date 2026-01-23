//
//  AuthServiceFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.23.
//

import Foundation

import Moya

import Data

protocol AuthServiceFactory: AuthAPIFactory, TokenStorageFactory {
    func makeAuthService() -> AuthService
    func makeAuthService(tokenStorage: TokenStorage, authAPIProvider: MoyaProvider<AuthAPI>) -> AuthService
}

extension AuthServiceFactory {
    func makeAuthService() -> AuthService {
        return makeAuthService(tokenStorage: makeTokenStorage(), authAPIProvider: makeAuthAPIProvider())
    }
    func makeAuthService(tokenStorage: TokenStorage, authAPIProvider: MoyaProvider<AuthAPI>) -> AuthService {
        return DefaultAuthService(tokenStorage: tokenStorage, authAPIProvider: authAPIProvider)
    }
}
