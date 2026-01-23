//
//  AddContentSelectViewModelFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.23.
//

import Foundation

import Domain
import Presentation

protocol AddContentSelectViewModelFactory: SearchContentsUseCaseFactory {
    func makeAddContentSelectViewModel() -> AddContentSelectViewModel
    func makeAddContentSelectViewModel(searchContentsUseCase: SearchContentsUseCase) -> AddContentSelectViewModel
}

extension AddContentSelectViewModelFactory {
    func makeAddContentSelectViewModel() -> AddContentSelectViewModel {
        return makeAddContentSelectViewModel(searchContentsUseCase: makeSearchContentsUseCase())
    }

    func makeAddContentSelectViewModel(searchContentsUseCase: SearchContentsUseCase) -> AddContentSelectViewModel {
        return DefaultAddContentSelectViewModel(useCase: searchContentsUseCase)
    }
}
