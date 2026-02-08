//
//  FetchKeywordsUseCase.swift
//  Domain
//
//  Created by 김호성 on 2026.02.08.
//

import Combine
import Foundation

import Entity
import Repository

public protocol FetchKeywordsUseCase {
    func fetchKeywords(for target: UserTarget) -> AnyPublisher<[KeywordEntity], Error>
}

public final class DefaultFetchKeywordsUseCase: FetchKeywordsUseCase {
    
    private let userRepository: UserRepository
    
    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    public func fetchKeywords(for target: UserTarget) -> AnyPublisher<[KeywordEntity], Error> {
        switch target {
        case .me:
            return userRepository.fetchMyKeywords()
        case let .user(id):
            return userRepository.fetchUserKeywords(userId: id)
        }
    }
}
