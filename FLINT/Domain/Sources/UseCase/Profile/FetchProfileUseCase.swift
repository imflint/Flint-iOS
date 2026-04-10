//
//  FetchProfileUseCase.swift
//  Domain
//
//  Created by 김호성 on 2026.02.08.
//

import Combine
import Foundation

import Entity
import Repository

public protocol FetchProfileUseCase {
    func callAsFunction(for target: UserTarget) -> AnyPublisher<UserProfileEntity, Error>
}

public final class DefaultFetchProfileUseCase: FetchProfileUseCase {
    
    private let userRepository: UserRepository
    
    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    public func callAsFunction(for target: UserTarget) -> AnyPublisher<UserProfileEntity, Error> {
        switch target {
        case .me:
            return userRepository.fetchMyProfile()
        case let .user(id):
            return userRepository.fetchUserProfile(userId: id)
        }
    }
}
