//
//  AuthServiceFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.23.
//

import Foundation

import Data

protocol AuthServiceFactory: AuthAPIProviderFactory, TokenStorageFactory {
    func makeAuthService() -> AuthService
}

extension AuthServiceFactory {
    func makeAuthService() -> AuthService {
        return DefaultAuthService(tokenStorage: makeTokenStorage(), authAPIProvider: makeAuthAPIProvider())
    }
}
