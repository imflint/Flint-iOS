//
//  FetchSessionUseCaseFactory.swift
//  FLINT
//
//  Created by Hosung.Kim on 2026.10.17.
//

import Foundation

import Domain

protocol FetchSessionUseCaseFactory: ExplorationRepositoryFactory {
    func makeFetchSessionUseCase() -> FetchSessionUseCase
}

extension FetchSessionUseCaseFactory {
    func makeFetchSessionUseCase() -> FetchSessionUseCase {
        return DefaultFetchSessionUseCase(explorationRepository: makeExplorationRepository())
    }
}
