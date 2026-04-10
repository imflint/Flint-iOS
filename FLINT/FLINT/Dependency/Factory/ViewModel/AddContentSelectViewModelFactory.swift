//
//  AddContentSelectViewModelFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.23.
//

import Foundation

import Presentation

protocol AddContentSelectViewModelFactory: SearchContentsUseCaseFactory, FetchPopularContentsUseCaseFactory {
    func makeAddContentSelectViewModel() -> AddContentSelectViewModel
}

extension AddContentSelectViewModelFactory {
    func makeAddContentSelectViewModel() -> AddContentSelectViewModel {
        return DefaultAddContentSelectViewModel(fetchPopularContentsUseCase: makeFetchPopularContentsUseCase(), searchContentsUseCase: makeSearchContentsUseCase())
    }
}
