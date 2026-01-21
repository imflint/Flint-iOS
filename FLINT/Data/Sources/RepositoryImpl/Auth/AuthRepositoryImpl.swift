//
//  File.swift
//  Data
//
//  Created by 김호성 on 2026.01.21.
//

import Combine
import Foundation

import Domain

import Networking

public final class DefaultAuthRepository: AuthRepository {
    
    private let authService: AuthService
    
    public init(authService: AuthService) {
        self.authService = authService
    }
    
    public func signup(_ signupInfoEntity: SignupInfoEntity) -> AnyPublisher<String, Error> {
        return authService.signup(signupInfoEntity)
            .tryMap({ try $0.userIdValue })
            .eraseToAnyPublisher()
    }
}
