//
//  SaveSessionProgressUseCaseFactory.swift
//  FLINT
//
//  Created by Hosung.Kim on 2026.10.17.
//

import Foundation

import Domain

protocol SaveSessionProgressUseCaseFactory: ExplorationRepositoryFactory {
    func makeSaveSessionProgressUseCase() -> SaveSessionProgressUseCase
}

extension SaveSessionProgressUseCaseFactory {
    func makeSaveSessionProgressUseCase() -> SaveSessionProgressUseCase {
        return DefaultSaveSessionProgressUseCase(explorationRepository: makeExplorationRepository())
    }
}
