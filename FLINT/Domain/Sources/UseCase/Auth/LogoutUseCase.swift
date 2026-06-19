//
//  LogoutUseCase.swift
//  Domain
//
//  Created by 소은 on 6/19/26.
//

import Combine
import Foundation

import Repository

public protocol LogoutUseCase {
    func callAsFunction() -> AnyPublisher<Void, Error>
}

public final class DefaultLogoutUseCase: LogoutUseCase {
    
    private let authRepository: AuthRepository
    
    public init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    public func callAsFunction() -> AnyPublisher<Void, Error> {
        return authRepository.logout()
    }
}
