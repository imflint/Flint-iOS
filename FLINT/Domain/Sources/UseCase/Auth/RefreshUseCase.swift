//
//  RefreshUseCase.swift
//  Domain
//
//  Created by Hosung.Kim on 2026.08.23.
//

import Combine
import Foundation

import Repository

public protocol RefreshUseCase {
    func callAsFunction() -> AnyPublisher<Void, Error>
}

public final class DefaultRefreshUseCase: RefreshUseCase {
    
    private let authRepository: AuthRepository
    
    public init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    public func callAsFunction() -> AnyPublisher<Void, Error> {
        return authRepository.refresh()
    }
}
