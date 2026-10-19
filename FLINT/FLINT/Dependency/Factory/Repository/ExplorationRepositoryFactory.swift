//
//  ExplorationRepositoryFactory.swift
//  FLINT
//
//  Created by Hosung.Kim on 2026.10.17.
//

import Foundation

import Data
import Domain

protocol ExplorationRepositoryFactory: ExplorationServiceFactory {
    func makeExplorationRepository() -> ExplorationRepository
}

extension ExplorationRepositoryFactory {
    func makeExplorationRepository() -> ExplorationRepository {
        return DefaultExplorationRepository(explorationService: makeExplorationService())
    }
}
