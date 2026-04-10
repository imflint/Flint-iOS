//
//  ExploreViewModelFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

import Presentation

protocol ExploreViewModelFactory: FetchExploreCollectionsUseCaseFactory {
    func makeExploreViewModel() -> ExploreViewModel
}

extension ExploreViewModelFactory {
    func makeExploreViewModel() -> ExploreViewModel {
        return DefaultExploreViewModel(fetchExploreCollectionsUseCase: makeFetchExploreCollectionsUseCase())
    }
}
