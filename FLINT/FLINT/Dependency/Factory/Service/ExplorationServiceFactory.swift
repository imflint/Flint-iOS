//
//  ExplorationServiceFactory.swift
//  FLINT
//
//  Created by Hosung.Kim on 2026.10.17.
//

import Foundation

import Data

protocol ExplorationServiceFactory: ExplorationAPIProviderFactory {
    func makeExplorationService() -> ExplorationService
}

extension ExplorationServiceFactory {
    func makeExplorationService() -> ExplorationService {
        return DefaultExplorationService(explorationAPIProvider: makeExplorationAPIProvider())
    }
}
