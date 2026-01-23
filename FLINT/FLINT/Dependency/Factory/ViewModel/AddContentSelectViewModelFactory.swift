//
//  AddContentSelectViewModelFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.23.
//

import Foundation

import Domain
import Presentation

protocol AddContentSelectViewModelFactory: SearchContentsUseCaseFactory, ContentsUseCaseFactory {
    func makeAddContentSelectViewModel() -> AddContentSelectViewModel
    func makeAddContentSelectViewModel(
        contentsUseCase: ContentsUseCase,
        searchContentsUseCase: SearchContentsUseCase
    ) -> AddContentSelectViewModel
}

extension AddContentSelectViewModelFactory {

    func makeAddContentSelectViewModel() -> AddContentSelectViewModel {
        return makeAddContentSelectViewModel(
            contentsUseCase: makeContentsUseCase(),
            searchContentsUseCase: makeSearchContentsUseCase()
        )
    }

    func makeAddContentSelectViewModel(
        contentsUseCase: ContentsUseCase,
        searchContentsUseCase: SearchContentsUseCase
    ) -> AddContentSelectViewModel {
        return DefaultAddContentSelectViewModel(
            contentsUseCase: contentsUseCase,
            searchContentsUseCase: searchContentsUseCase
        )
    }
}
