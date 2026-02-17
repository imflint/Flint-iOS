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
}

extension WithDrawUseCaseFactory {
    func makeWithDrawUseCase() -> WithDrawUseCase {
        return DefaultWithDrawUseCase(authRepository: makeAuthRepository())
    }
}
