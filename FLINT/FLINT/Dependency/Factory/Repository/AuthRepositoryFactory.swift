//
//  AuthRepositoryFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.23.
//

import Foundation

import Data
import Domain

protocol AuthRepositoryFactory: AuthServiceFactory {
    func makeAuthRepository() -> AuthRepository
    func makeAuthRepository(authService: AuthService) -> AuthRepository
}

extension AuthRepositoryFactory {
    func makeAuthRepository() -> AuthRepository {
        return makeAuthRepository(authService: makeAuthService())
    }
    func makeAuthRepository(authService: AuthService) -> AuthRepository {
        return DefaultAuthRepository(authService: authService)
    }
}
