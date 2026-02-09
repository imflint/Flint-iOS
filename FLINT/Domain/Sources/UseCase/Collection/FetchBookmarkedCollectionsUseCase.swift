//
//  FetchBookmarkedCollectionsUseCase.swift
//  Domain
//
//  Created by 김호성 on 2026.02.08.
//

import Combine
import Foundation

import Entity
import Repository

public protocol FetchBookmarkedCollectionsUseCase {
    func fetchBookmarkedCollections(for target: UserTarget) -> AnyPublisher<[CollectionEntity], Error>
}

public final class DefaultFetchBookmarkedCollectionsUseCase: FetchBookmarkedCollectionsUseCase {
    
    private let userRepository: UserRepository
    
    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    public func fetchBookmarkedCollections(for target: UserTarget) -> AnyPublisher<[CollectionEntity], Error> {
        switch target {
        case .me:
            return userRepository.fetchMyBookmarkedCollections()
        case let .user(id):
            return userRepository.fetchUserBookmarkedCollections(userId: id)
        }
    }
}
