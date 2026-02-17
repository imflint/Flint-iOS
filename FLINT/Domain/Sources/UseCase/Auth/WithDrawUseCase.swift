//
//  WithDrawUseCase.swift
//  Domain
//
//  Created by 김호성 on 2026.01.24.
//

import Combine
import Foundation

import Entity
import Repository

public protocol WithDrawUseCase {
    func callAsFunction() -> AnyPublisher<Void, Error>
}

public final class DefaultWithDrawUseCase: WithDrawUseCase {
    
    private let authRepository: AuthRepository
    
    public init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    public func callAsFunction() -> AnyPublisher<Void, Error> {
        return authRepository.withDraw()
    }
}
