//
//  RecalculateKeywordsUseCase.swift
//  Domain
//
//  Created by 진소은 on 6/20/26.
//

import Combine
import Foundation

import Repository

public protocol RecalculateKeywordsUseCase {
    func callAsFunction() -> AnyPublisher<Void, Error>
}

public final class DefaultRecalculateKeywordsUseCase: RecalculateKeywordsUseCase {

    private let userRepository: UserRepository

    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    public func callAsFunction() -> AnyPublisher<Void, Error> {
        return userRepository.recalculateMyKeywords()
    }
}
