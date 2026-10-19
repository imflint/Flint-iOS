//
//  ExplorationRepository.swift
//  Domain
//
//  Created by Hosung.Kim on 2026.10.14.
//

import Combine

import Entity

public protocol ExplorationRepository {
    func fetchSession() -> AnyPublisher<SessionEntity, any Error>
    func saveSessionProgress(lastViewedPosition: Int) -> AnyPublisher<SessionEntity, any Error>
}
