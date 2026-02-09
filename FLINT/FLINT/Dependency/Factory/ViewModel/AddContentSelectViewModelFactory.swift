//
//  AddContentSelectViewModelFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.23.
//

import Foundation

import Domain
import Presentation

protocol AddContentSelectViewModelFactory: SearchContentsUseCaseFactory, FetchPopularContentsUseCaseFactory {
    func makeAddContentSelectViewModel() -> AddContentSelectViewModel
    func makeAddContentSelectViewModel(
        fetchPopularContentsUseCase: FetchPopularContentsUseCase,
        searchContentsUseCase: SearchContentsUseCase
    ) -> AddContentSelectViewModel
}

extension AddContentSelectViewModelFactory {

    func makeAddContentSelectViewModel() -> AddContentSelectViewModel {
        return makeAddContentSelectViewModel(
            fetchPopularContentsUseCase: makeFetchPopularContentsUseCase(),
            searchContentsUseCase: makeSearchContentsUseCase()
        )
    }

    func makeAddContentSelectViewModel(
        fetchPopularContentsUseCase: FetchPopularContentsUseCase,
        searchContentsUseCase: SearchContentsUseCase
    ) -> AddContentSelectViewModel {
        return DefaultAddContentSelectViewModel(
            fetchPopularContentsUseCase: fetchPopularContentsUseCase,
            searchContentsUseCase: searchContentsUseCase
        )
    }
}
