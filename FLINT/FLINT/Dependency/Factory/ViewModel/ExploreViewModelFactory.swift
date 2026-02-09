//
//  ExploreViewModelFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

import Domain
import Presentation

protocol ExploreViewModelFactory: FetchExploreCollectionsUseCaseFactory {
    func makeExploreViewModel() -> ExploreViewModel
    func makeExploreViewModel(fetchExploreCollectionsUseCase: FetchExploreCollectionsUseCase) -> ExploreViewModel
}

extension ExploreViewModelFactory {
    func makeExploreViewModel() -> ExploreViewModel {
        return makeExploreViewModel(fetchExploreCollectionsUseCase: makeFetchExploreCollectionsUseCase())
    }
    func makeExploreViewModel(fetchExploreCollectionsUseCase: FetchExploreCollectionsUseCase) -> ExploreViewModel {
        return DefaultExploreViewModel(fetchExploreCollectionsUseCase: fetchExploreCollectionsUseCase)
    }
}
