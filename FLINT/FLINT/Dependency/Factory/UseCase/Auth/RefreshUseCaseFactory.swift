//
//  RefreshUseCaseFactory.swift
//  FLINT
//
//  Created by Hosung.Kim on 2026.08.23.
//

import Foundation

import Domain

protocol RefreshUseCaseFactory: AuthRepositoryFactory {
    func makeRefreshUseCase() -> RefreshUseCase
}

extension RefreshUseCaseFactory {
    func makeRefreshUseCase() -> RefreshUseCase {
        return DefaultRefreshUseCase(authRepository: makeAuthRepository())
    }
}
