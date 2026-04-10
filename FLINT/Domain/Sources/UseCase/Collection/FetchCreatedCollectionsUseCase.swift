//
//  FetchCreatedCollectionsUseCase.swift
//  Domain
//
//  Created by 김호성 on 2026.02.08.
//

import Combine
import Foundation

import Entity
import Repository

public protocol FetchCreatedCollectionsUseCase {
    func callAsFunction(for target: UserTarget) -> AnyPublisher<[CollectionEntity], Error>
}

public final class DefaultFetchCreatedCollectionsUseCase: FetchCreatedCollectionsUseCase {
    
    private let userRepository: UserRepository
    
    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    public func callAsFunction(for target: UserTarget) -> AnyPublisher<[CollectionEntity], Error> {
        switch target {
        case .me:
            return userRepository.fetchMyCreatedCollections()
        case let .user(id):
            return userRepository.fetchUserCreatedCollections(userId: id)
        }
    }
}
