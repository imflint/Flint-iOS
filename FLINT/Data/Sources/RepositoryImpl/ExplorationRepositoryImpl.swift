//
//  ExplorationRepositoryImpl.swift
//  Data
//
//  Created by Hosung.Kim on 2026.10.14.
//

import Combine
import Foundation

import Domain

import DTO
import Networking

public final class DefaultExplorationRepository: ExplorationRepository {
    
    private let explorationService: ExplorationService
    
    public init(explorationService: ExplorationService) {
        self.explorationService = explorationService
    }
    
    public func fetchSession() -> AnyPublisher<Entity.SessionEntity, any Error> {
        return explorationService.fetchSession()
            .tryMap(SessionEntity.init)
            .eraseToAnyPublisher()
    }
    
    public func saveSessionProgress(lastViewedPosition: Int) -> AnyPublisher<Entity.SessionEntity, any Error> {
        return explorationService.saveSessionProgress(lastViewedPosition: lastViewedPosition)
            .tryMap(SessionEntity.init)
            .eraseToAnyPublisher()
    }
}
