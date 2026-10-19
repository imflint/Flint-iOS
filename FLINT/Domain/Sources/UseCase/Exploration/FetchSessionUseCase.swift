//
//  FetchSessionUseCase.swift
//  Domain
//
//  Created by Hosung.Kim on 2026.10.14.
//

import Combine
import Foundation

import Entity
import Repository

public protocol FetchSessionUseCase {
    func callAsFunction() -> AnyPublisher<SessionEntity, any Error>
}

public final class DefaultFetchSessionUseCase: FetchSessionUseCase {
    
    private let explorationRepository: ExplorationRepository
    
    public init(explorationRepository: ExplorationRepository) {
        self.explorationRepository = explorationRepository
    }
    
    public func callAsFunction() -> AnyPublisher<Entity.SessionEntity, any Error> {
        return explorationRepository.fetchSession()
    }
}
