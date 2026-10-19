//
//  ExplorationService.swift
//  Data
//
//  Created by Hosung.Kim on 2026.10.14.
//

import Combine
import Foundation

import CombineMoya
import Moya

import DTO

public protocol ExplorationService {
    func fetchSession() -> AnyPublisher<SessionDTO, any Error>
    func saveSessionProgress(lastViewedPosition: Int) -> AnyPublisher<SessionDTO, any Error>
}

public final class DefaultExplorationService: ExplorationService {
    
    private let explorationAPIProvider: MoyaProvider<ExplorationAPI>
    
    public init(explorationAPIProvider: MoyaProvider<ExplorationAPI>) {
        self.explorationAPIProvider = explorationAPIProvider
    }
    
    public func fetchSession() -> AnyPublisher<SessionDTO, any Error> {
        return explorationAPIProvider.requestPublisher(.fetchSession)
            .mapBaseResponseData(SessionDTO.self)
    }
    
    public func saveSessionProgress(lastViewedPosition: Int) -> AnyPublisher<SessionDTO, any Error> {
        return explorationAPIProvider.requestPublisher(.saveSessionProgress(lastViewedPosition: lastViewedPosition))
            .mapBaseResponseData(SessionDTO.self)
    }
}
