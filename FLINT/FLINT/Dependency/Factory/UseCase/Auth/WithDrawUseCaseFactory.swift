//
//  WithDrawUseCaseFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.09.
//

import Foundation

import Domain

protocol WithDrawUseCaseFactory: AuthRepositoryFactory {
    func makeWithDrawUseCase() -> WithDrawUseCase
    func makeWithDrawUseCase(authRepository: AuthRepository) -> WithDrawUseCase
}

extension WithDrawUseCaseFactory {
    func makeWithDrawUseCase() -> WithDrawUseCase {
        return makeWithDrawUseCase(authRepository: makeAuthRepository())
    }
    func makeWithDrawUseCase(authRepository: AuthRepository) -> WithDrawUseCase {
        return DefaultWithDrawUseCase(authRepository: authRepository)
    }
}
