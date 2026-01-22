//
//  File.swift
//  Domain
//
//  Created by 김호성 on 2026.01.21.
//

import Combine
import Foundation

import Entity
import Repository

public protocol SignupUseCase {
    func signup(_ signupInfoEntity: SignupInfoEntity) -> AnyPublisher<String, Error>
}

public final class DefaultSignupUseCase: SignupUseCase {
    
    let authRepository: AuthRepository
    
    public init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    public func signup(_ signupInfoEntity: SignupInfoEntity) -> AnyPublisher<String, Error> {
        return authRepository.signup(signupInfoEntity)
    }
}
