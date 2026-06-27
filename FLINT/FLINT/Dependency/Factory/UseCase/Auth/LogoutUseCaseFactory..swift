//
//  LogoutUseCaseFactory..swift
//  FLINT
//
//  Created by 소은 on 6/19/26.
//

import Foundation

import Domain

protocol LogoutUseCaseFactory: AuthRepositoryFactory {
    func makeLogoutUseCase() -> LogoutUseCase
}

extension LogoutUseCaseFactory {
    func makeLogoutUseCase() -> LogoutUseCase {
        return DefaultLogoutUseCase(authRepository: makeAuthRepository())
    }
}
