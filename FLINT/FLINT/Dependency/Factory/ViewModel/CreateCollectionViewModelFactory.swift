//
//  CreateCollectionViewModel.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.02.
//

import Foundation

import Domain
import Presentation

protocol CreateCollectionViewModelFactory: CreateCollectionUseCaseFactory {
    func makeCreateCollectionViewModel() -> CreateCollectionViewModel
    func makeCreateCollectionViewModel(createCollectionUseCase: CreateCollectionUseCase) -> CreateCollectionViewModel
}

extension CreateCollectionViewModelFactory {
    func makeCreateCollectionViewModel() -> CreateCollectionViewModel {
        return makeCreateCollectionViewModel(createCollectionUseCase: makeCreateCollectionUseCase())
    }
    func makeCreateCollectionViewModel(createCollectionUseCase: CreateCollectionUseCase) -> CreateCollectionViewModel {
        return DefaultCreateCollectionViewModel(createCollectionUseCase: createCollectionUseCase)
    }
}
