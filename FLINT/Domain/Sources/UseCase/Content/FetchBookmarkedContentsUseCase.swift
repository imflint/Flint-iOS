//
//  FetchBookmarkedContentsUseCase.swift
//  Domain
//
//  Created by 김호성 on 2026.02.08.
//

import Combine
import Foundation

import Entity
import Repository

public protocol FetchBookmarkedContentsUseCase {
    func callAsFunction(for target: UserTarget) -> AnyPublisher<[ContentInfoEntity], Error>
}

public final class DefaultFetchBookmarkedContentsUseCase: FetchBookmarkedContentsUseCase {
    
    private let contentRepository: ContentRepository
    private let userRepository: UserRepository
    
    public init(contentRepository: ContentRepository, userRepository: UserRepository) {
        self.contentRepository = contentRepository
        self.userRepository = userRepository
    }
    
    public func callAsFunction(for target: UserTarget) -> AnyPublisher<[ContentInfoEntity], Error> {
        switch target {
        case .me:
            return contentRepository.fetchMyBookmarkedContentsPage(cursor: nil, size: nil)
                .map { $0.items }
                .eraseToAnyPublisher()
        case let .user(id):
            return userRepository.fetchUserBookmarkedContents(userId: id)
        }
    }
}
