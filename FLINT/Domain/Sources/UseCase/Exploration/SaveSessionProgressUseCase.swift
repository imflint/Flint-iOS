//
//  SaveSessionProgressUseCase.swift
//  Domain
//
//  Created by Hosung.Kim on 2026.10.14.
//

import Combine
import Foundation

import Entity
import Repository

public protocol SaveSessionProgressUseCase {
    func callAsFunction(lastViewedPosition: Int) -> AnyPublisher<SessionEntity, any Error>
}

public final class DefaultSaveSessionProgressUseCase: SaveSessionProgressUseCase {
    
    private let explorationRepository: ExplorationRepository
    
    public init(explorationRepository: ExplorationRepository) {
        self.explorationRepository = explorationRepository
    }
    
    public func callAsFunction(lastViewedPosition: Int) -> AnyPublisher<Entity.SessionEntity, any Error> {
        return explorationRepository.saveSessionProgress(lastViewedPosition: lastViewedPosition)
    }
}
