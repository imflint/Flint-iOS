//
//  File.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

import Domain
import Presentation

protocol ExploreViewModelFactory: ExploreUseCaseFactory {
    func makeExploreViewModel() -> ExploreViewModel
    func makeExploreViewModel(exploreUseCase: ExploreUseCase) -> ExploreViewModel
}

extension ExploreViewModelFactory {
    func makeExploreViewModel() -> ExploreViewModel {
        return makeExploreViewModel(exploreUseCase: makeExploreUseCase())
    }
    func makeExploreViewModel(exploreUseCase: ExploreUseCase) -> ExploreViewModel {
        return DefaultExploreViewModel(exploreUseCase: exploreUseCase)
    }
}
